import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../../../../core/api/paginated.dart';
import '../../../feeding/data/models/feeding_record_model.dart';
import '../../../health/data/models/medical_record_model.dart';
import '../../../health/data/models/vaccination_model.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../notes/data/models/note_model.dart';
import '../../../rabbits/data/models/rabbit_photo_model.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../models/journal_entry.dart';

/// Собирает ленту записей смены из пяти источников.
///
/// Запроса «покажи, что записали за смену» на сервере нет: кормления, лечение,
/// прививки, задачи и заметки лежат по разным адресам, поэтому пять списков
/// тянутся параллельно и склеиваются по времени здесь.
///
/// Кормления и задачи разбираются своими моделями: те теперь забирают из
/// ответа связанные корм, кролика, клетку и автора записи. А вот модели
/// лечения и прививок связанного кролика всё ещё отбрасывают, поэтому его имя
/// достаётся из сырого JSON — иначе строка журнала превратилась бы в «Ушной
/// клещ кролику #4», то есть ни во что.
class JournalRepository {
  JournalRepository(this._api);

  final ApiClient _api;

  /// Потолок сервера на размер страницы. Смена длиннее ста записей в журнал
  /// целиком не поместится — для этого нужен отдельный эндпоинт с пагинацией.
  static const _pageLimit = 100;

  Future<List<JournalEntry>> load({
    required DateTime from,
    required DateTime to,
  }) async {
    final sources = await Future.wait([
      _feedings(from, to),
      _treatments(from, to),
      _vaccinations(from, to),
      _closedTasks(),
      _notes(from, to),
      _photos(from, to),
    ]);

    // Границы периода проверяются ещё раз здесь: у задач сервер их вовсе не
    // применяет, а у остальных источников фильтр работает по календарной дате
    // и на краях периода прихватывает лишнее.
    return [
      for (final source in sources)
        for (final entry in source)
          if (!entry.at.isBefore(from) && !entry.at.isAfter(to)) entry,
    ]..sort((a, b) => b.at.compareTo(a.at));
  }

  Future<List<JournalEntry>> _feedings(DateTime from, DateTime to) async {
    final items = await _items(ApiEndpoints.feedingRecords, {
      'limit': _pageLimit,
      'sort_by': 'fed_at',
      'sort_order': 'DESC',
      // `fed_at` хранит момент времени, поэтому границы тоже с временем:
      // от даты без часов конец периода пришёлся бы на полночь и отрезал
      // весь сегодняшний день.
      'from_date': from.toIso8601String(),
      'to_date': to.toIso8601String(),
    });

    return [
      for (final item in items) _feedingEntry(item),
    ];
  }

  JournalEntry _feedingEntry(Map<String, dynamic> item) {
    final record = FeedingRecord.fromJson(item);

    return JournalEntry(
      kind: JournalKind.feeding,
      at: record.fedAt,
      hasTime: true,
      title: record.feed?.name,
      rabbitName: record.rabbit?.name,
      cageNumber: record.cage?.number,
      author: record.author?.fullName,
      formArgs: record,
    );
  }

  Future<List<JournalEntry>> _treatments(DateTime from, DateTime to) async {
    final items = await _items(ApiEndpoints.medicalRecords, {
      'limit': _pageLimit,
      'sort_by': 'started_at',
      'sort_order': 'DESC',
      'from_date': _day(from),
      'to_date': _day(to),
    });

    return [
      for (final item in items) _treatmentEntry(item),
    ];
  }

  JournalEntry _treatmentEntry(Map<String, dynamic> item) {
    final record = MedicalRecord.fromJson(item);
    final diagnosis = record.diagnosis?.trim();

    return JournalEntry(
      kind: JournalKind.treatment,
      at: record.startedAt,
      hasTime: false,
      // Диагноз точнее симптомов, но его ставят не всегда — тогда в строке
      // остаётся то, с чего лечение началось.
      title: diagnosis == null || diagnosis.isEmpty ? record.symptoms : diagnosis,
      rabbitName: _text(item['rabbit'], 'name'),
      author: record.veterinarian,
      formArgs: record,
    );
  }

  Future<List<JournalEntry>> _vaccinations(DateTime from, DateTime to) async {
    final items = await _items(ApiEndpoints.vaccinations, {
      'limit': _pageLimit,
      'sort_by': 'vaccination_date',
      'sort_order': 'DESC',
      'from_date': _day(from),
      'to_date': _day(to),
    });

    return [
      for (final item in items) _vaccinationEntry(item),
    ];
  }

  JournalEntry _vaccinationEntry(Map<String, dynamic> item) {
    final vaccination = Vaccination.fromJson(item);

    return JournalEntry(
      kind: JournalKind.vaccination,
      at: vaccination.vaccinationDate,
      hasTime: false,
      title: vaccination.vaccineName,
      rabbitName: _text(item['rabbit'], 'name'),
      author: vaccination.veterinarian,
      formArgs: vaccination,
    );
  }

  /// Закрытые задачи приходят без фильтра по периоду.
  ///
  /// `from_date` и `to_date` у задач смотрят на срок исполнения, а не на
  /// момент закрытия, и сортировать по `completed_at` сервер не умеет —
  /// поэтому берём последние закрытые и отбираем нужные по времени закрытия
  /// уже здесь.
  Future<List<JournalEntry>> _closedTasks() async {
    final items = await _items(ApiEndpoints.tasks, {
      'limit': _pageLimit,
      'status': 'completed',
      'sort_by': 'created_at',
      'sort_order': 'DESC',
    });

    final entries = <JournalEntry>[];
    for (final item in items) {
      final task = Task.fromJson(item);
      final completedAt = task.completedAt;
      if (completedAt == null) continue;

      entries.add(JournalEntry(
        kind: JournalKind.task,
        at: completedAt,
        hasTime: true,
        title: task.title,
        rabbitName: task.rabbit?.label,
        cageNumber: task.cage?.number,
        author: task.author?.fullName,
        formArgs: task,
      ));
    }
    return entries;
  }

  Future<List<JournalEntry>> _notes(DateTime from, DateTime to) async {
    final items = await _items(ApiEndpoints.notes, {
      'limit': _pageLimit,
      'sort_by': 'created_at',
      'sort_order': 'DESC',
      'from_date': from.toIso8601String(),
      'to_date': to.toIso8601String(),
    });

    return [
      for (final item in items) _noteEntry(item),
    ];
  }

  JournalEntry _noteEntry(Map<String, dynamic> item) {
    final note = NoteModel.fromJson(item);

    return JournalEntry(
      kind: JournalKind.note,
      at: note.createdAt ?? DateTime.now(),
      hasTime: true,
      title: note.content,
      rabbitName: note.rabbit?.label,
      cageNumber: note.cage?.number,
      author: note.author?.fullName,
      formArgs: note,
    );
  }

  Future<List<JournalEntry>> _photos(DateTime from, DateTime to) async {
    final items = await _items(ApiEndpoints.photos, {
      'limit': _pageLimit,
      'sort_by': 'created_at',
      'sort_order': 'DESC',
      'from_date': from.toIso8601String(),
      'to_date': to.toIso8601String(),
    });

    return [
      for (final item in items) _photoEntry(item),
    ];
  }

  JournalEntry _photoEntry(Map<String, dynamic> item) {
    final photo = RabbitPhoto.fromJson(item);
    final caption = photo.caption?.trim();

    return JournalEntry(
      kind: JournalKind.photo,
      at: photo.createdAt ?? DateTime.now(),
      hasTime: true,
      // Без подписи заголовком не может быть null: общий фолбэк на экране
      // придуман для кормления («Корм неизвестен») и здесь бы соврал.
      title: caption == null || caption.isEmpty ? null : caption,
      rabbitName: photo.rabbit?.label,
      author: photo.author?.fullName,
      imageUrl: ImageUrlHelper.getFullImageUrl(photo.url),
      formArgs: photo,
    );
  }

  Future<List<Map<String, dynamic>>> _items(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await _api.get(path, queryParameters: query);
      if (response.data['success'] != true) {
        throw const ApiFailure(ApiFailureKind.server);
      }
      return [
        for (final item in itemsOf(response.data['data']))
          item as Map<String, dynamic>,
      ];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  /// Значение вложенной связи, если сервер её привёз. Нужно там, где модель
  /// фичи связь ещё выбрасывает, — в лечении и прививках.
  static String? _text(dynamic node, String key) {
    if (node is! Map) return null;
    final value = node[key]?.toString().trim();
    return value == null || value.isEmpty ? null : value;
  }

  static String _day(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
