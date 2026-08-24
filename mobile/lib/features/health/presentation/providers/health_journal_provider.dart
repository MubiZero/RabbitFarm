import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/medical_record_model.dart';
import '../../data/models/vaccination_model.dart';
import '../../data/repositories/vaccinations_repository.dart';
import 'medical_records_provider.dart';

/// Что именно записано.
enum HealthEntryKind {
  vaccination,
  treatment;

  /// Форма, в которой эту запись правят.
  String get formRoute => switch (this) {
        HealthEntryKind.vaccination => '/vaccinations/form',
        HealthEntryKind.treatment => '/medical-records/form',
      };
}

/// Одна строка журнала здоровья.
///
/// Прививки и лечение лежат в разных таблицах и приходят разными моделями, но
/// фермер спрашивает не «покажи вакцинации», а «что было с этим кроликом».
/// Обе записи приводятся к общему виду, чтобы лента сортировалась по дате и
/// рисовалась одним виджетом. Готовых подписей здесь нет: они зависят от
/// языка, а слой данных о нём не знает.
class HealthEntry {
  final HealthEntryKind kind;

  /// День записи — дата прививки или начало лечения. По нему лента и
  /// сортируется. Времени в данных нет: обе записи датируются днём.
  final DateTime at;

  /// Название прививки, диагноз, а если диагноза нет — описание симптомов.
  final String title;

  final int rabbitId;

  /// Кличка кролика. Сервер кладёт её в каждый ответ, но модели `Vaccination`
  /// и `MedicalRecord` помечают поле `rabbit` как несериализуемое, поэтому в
  /// приложении здесь пока всегда `null`. Экран в этом случае просто не
  /// показывает строку «кому»: выдумывать вместо клички номер записи в базе
  /// значит показать фермеру то, чего он у себя на ферме не видел.
  final String? rabbitName;

  /// Когда прививать снова. Только у прививки.
  final DateTime? nextDate;

  /// Чем закончилось лечение и когда. Только у лечения.
  final MedicalOutcome? outcome;
  final DateTime? endedAt;

  /// Исходная запись: с ней открывается форма правки.
  final Object formArgs;

  const HealthEntry({
    required this.kind,
    required this.at,
    required this.title,
    required this.rabbitId,
    required this.formArgs,
    this.rabbitName,
    this.nextDate,
    this.outcome,
    this.endedAt,
  });

  factory HealthEntry.fromVaccination(Vaccination vaccination) => HealthEntry(
        kind: HealthEntryKind.vaccination,
        at: vaccination.vaccinationDate,
        title: vaccination.vaccineName,
        rabbitId: vaccination.rabbitId,
        rabbitName: vaccination.rabbit?.label,
        nextDate: vaccination.nextVaccinationDate,
        formArgs: vaccination,
      );

  /// Диагноз может быть ещё не поставлен, а симптомы записаны всегда: строка
  /// «что было» не должна оставаться пустой у свежей записи.
  factory HealthEntry.fromMedicalRecord(MedicalRecord record) {
    final diagnosis = record.diagnosis?.trim();

    return HealthEntry(
      kind: HealthEntryKind.treatment,
      at: record.startedAt,
      title: diagnosis != null && diagnosis.isNotEmpty
          ? diagnosis
          : record.symptoms.trim(),
      rabbitId: record.rabbitId,
      rabbitName: record.rabbit?.label,
      outcome: record.outcome,
      endedAt: record.endedAt,
      formArgs: record,
    );
  }
}

/// Сколько записей тянуть из каждого источника.
///
/// Сервер отдаёт прививки и лечение двумя разными списками, поэтому лента
/// склеивается здесь, и «последнее» получается из двух окон по [_sourceLimit].
/// Для журнала здоровья это приемлемо: за окном в полсотни записей на каждый
/// вид фермер уже смотрит историю конкретного кролика, а не всё стадо.
const _sourceLimit = 50;

/// Лента здоровья: прививки и лечение вперемешку, свежее сверху.
///
/// Аргумент — id кролика или `null` для всего стада. Фильтр по кролику оба
/// источника принимают сами, поэтому «вся история этого кролика» — это не
/// отбор загруженного, а два узких запроса.
final healthJournalProvider = FutureProvider.autoDispose
    .family<List<HealthEntry>, int?>((ref, rabbitId) async {
  final vaccinationsRepository = ref.watch(vaccinationsRepositoryProvider);
  final medicalRepository = ref.watch(medicalRecordsRepositoryProvider);

  final vaccinations = <Vaccination>[];
  final treatments = <MedicalRecord>[];

  // Оба запроса уходят разом: последовательно это две задержки сети подряд.
  // `Future.wait` дожидается обоих даже при ошибке одного, поэтому второй
  // ответ не остаётся необработанным.
  await Future.wait([
    vaccinationsRepository
        .getVaccinations(limit: _sourceLimit, rabbitId: rabbitId)
        .then(vaccinations.addAll),
    medicalRepository
        .getMedicalRecords(
          limit: _sourceLimit,
          rabbitId: rabbitId,
          sortBy: 'started_at',
          sortOrder: 'DESC',
        )
        .then(treatments.addAll),
  ]);

  return <HealthEntry>[
    for (final vaccination in vaccinations)
      HealthEntry.fromVaccination(vaccination),
    for (final treatment in treatments)
      HealthEntry.fromMedicalRecord(treatment),
  ]..sort((a, b) => b.at.compareTo(a.at));
});
