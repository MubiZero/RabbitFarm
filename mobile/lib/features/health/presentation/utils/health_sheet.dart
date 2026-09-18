/// Карта здоровья кролика — лист, который несут ветеринару.
///
/// Ветеринар не работает в чужом приложении: он смотрит бумагу и спрашивает
/// «чем кололи и когда». До сих пор ответ на это лежал в приложении и не
/// доставался оттуда никак — ни печатью, ни файлом.
///
/// Чистые функции: и то, что попадёт на бумагу, и то, что уйдёт таблицей,
/// проверяется тестом без принтера и без диалога «поделиться». Разметка, а не
/// виджеты пакета `pdf`, — по той же причине, что и у плана окролов: в его
/// встроенных шрифтах нет кириллицы (см. `core/printing/print_html.dart`).
library;

import 'package:intl/intl.dart';

import '../../../../core/export/csv.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../data/models/medical_record_model.dart';
import '../../data/models/vaccination_model.dart';


/// Что нужно листу помимо самих записей. Собирается на экране: слой данных о
/// кличке и породе кролика знает, а о языке читателя — нет.
class HealthSheetRabbit {
  const HealthSheetRabbit({
    required this.name,
    this.tagId,
    this.breed,
    this.sex,
    this.birthDate,
    this.weight,
  });

  final String name;
  final String? tagId;
  final String? breed;
  final String? sex;
  final DateTime? birthDate;
  final double? weight;
}

String buildHealthSheetHtml({
  required HealthSheetRabbit rabbit,
  required List<Vaccination> vaccinations,
  required List<MedicalRecord> treatments,
  required AppLocalizations l10n,
  required String dateLocale,
  String Function(MedicalOutcome outcome)? outcomeLabel,
  DateTime? printedAt,
}) {
  final day = DateFormat('d MMM y', dateLocale);
  final printedDay = DateFormat('d MMM y', dateLocale);

  final facts = <(String, String?)>[
    (l10n.rabbitTagLine(rabbit.tagId ?? _dash), rabbit.tagId),
    (l10n.rabbitBreed, rabbit.breed),
    (l10n.rabbitSex, rabbit.sex),
    (
      l10n.rabbitBirthDate,
      rabbit.birthDate == null ? null : day.format(rabbit.birthDate!)
    ),
    (
      l10n.rabbitWeight,
      rabbit.weight == null
          ? null
          : '${csvNumber(rabbit.weight)} ${l10n.unitKg}'
    ),
  ];

  final head = StringBuffer();
  // Бирка показывается отдельной строкой заголовка, остальное — списком:
  // ветеринар ищет глазами кличку и номер, а не читает таблицу сверху вниз.
  for (final (label, value) in facts.skip(1)) {
    if (value == null || value.trim().isEmpty) continue;
    head.write('<li><b>${_esc(label)}:</b> ${_esc(value)}</li>');
  }

  final vaccinationRows = StringBuffer();
  for (final item in vaccinations) {
    vaccinationRows.write(
      '<tr>'
      '<td class="day">${_esc(day.format(item.vaccinationDate))}</td>'
      '<td>${_esc(item.vaccineName)}</td>'
      '<td class="day">${_esc(item.nextVaccinationDate == null ? _dash : day.format(item.nextVaccinationDate!))}</td>'
      '<td>${_esc(item.veterinarian ?? _dash)}</td>'
      '</tr>',
    );
  }

  final treatmentRows = StringBuffer();
  for (final item in treatments) {
    final period = item.endedAt == null
        ? day.format(item.startedAt)
        : '${day.format(item.startedAt)} — ${day.format(item.endedAt!)}';
    treatmentRows.write(
      '<tr>'
      '<td class="day">${_esc(period)}</td>'
      '<td>${_esc(item.diagnosis ?? item.symptoms)}</td>'
      '<td>${_esc(item.treatment ?? _dash)}</td>'
      '<td>${_esc(item.medication ?? _dash)}</td>'
      '<td>${_esc(outcomeLabel?.call(item.outcome) ?? item.outcome.name)}</td>'
      '</tr>',
    );
  }

  return '<!DOCTYPE html>'
      '<html><head><meta charset="utf-8"><style>$_css</style></head><body>'
      '<h1>${_esc(l10n.healthSheetTitle(rabbit.name))}</h1>'
      '<p class="tag">${_esc(rabbit.tagId == null ? _dash : l10n.rabbitTagLine(rabbit.tagId!))}</p>'
      '<ul class="facts">$head</ul>'
      '<h2>${_esc(l10n.vaccinationsTitle)}</h2>'
      '${vaccinations.isEmpty ? '<p class="empty">${_esc(l10n.healthSheetNoVaccinations)}</p>' : '<table>'
          '<thead><tr>'
          '<th>${_esc(l10n.vaccFormDate)}</th>'
          '<th>${_esc(l10n.vaccFormName)}</th>'
          '<th>${_esc(l10n.healthSheetNextDate)}</th>'
          '<th>${_esc(l10n.vaccFormVet)}</th>'
          '</tr></thead><tbody>$vaccinationRows</tbody></table>'}'
      '<h2>${_esc(l10n.medTitle)}</h2>'
      '${treatments.isEmpty ? '<p class="empty">${_esc(l10n.healthSheetNoTreatments)}</p>' : '<table>'
          '<thead><tr>'
          '<th>${_esc(l10n.healthSheetPeriod)}</th>'
          '<th>${_esc(l10n.medDiagnosis)}</th>'
          '<th>${_esc(l10n.medTreatment)}</th>'
          '<th>${_esc(l10n.medMedication)}</th>'
          '<th>${_esc(l10n.medFormOutcome)}</th>'
          '</tr></thead><tbody>$treatmentRows</tbody></table>'}'
      '<p class="printed">${_esc(l10n.kindlingPlanPrintedAt(printedDay.format(printedAt ?? DateTime.now())))}</p>'
      '</body></html>';
}

/// Та же карта таблицей — для тех, кто ведёт своё в Excel.
///
/// Прививки и лечение идут одним списком с колонкой «что это»: два отдельных
/// файла человеку пришлось бы сводить руками, а сортировка по дате в таблице
/// делается одним щелчком.
String buildHealthSheetCsv({
  required HealthSheetRabbit rabbit,
  required List<Vaccination> vaccinations,
  required List<MedicalRecord> treatments,
  required AppLocalizations l10n,
  String Function(MedicalOutcome outcome)? outcomeLabel,
}) {
  final day = DateFormat('dd.MM.yyyy');

  final rows = <List<String>>[
    [
      l10n.healthSheetColKind,
      l10n.financeDate,
      l10n.healthSheetColWhat,
      l10n.healthSheetColDetails,
      l10n.medMedication,
      l10n.healthSheetNextDate,
      l10n.medFormOutcome,
      l10n.vaccFormVet,
      l10n.txFormAmount,
    ],
  ];

  for (final item in vaccinations) {
    rows.add([
      l10n.journalKindVaccination,
      day.format(item.vaccinationDate),
      item.vaccineName,
      item.notes ?? '',
      '',
      item.nextVaccinationDate == null
          ? ''
          : day.format(item.nextVaccinationDate!),
      '',
      item.veterinarian ?? '',
      csvNumber(item.cost),
    ]);
  }

  for (final item in treatments) {
    rows.add([
      l10n.journalKindTreatment,
      day.format(item.startedAt),
      item.diagnosis ?? item.symptoms,
      item.treatment ?? '',
      item.medication ?? '',
      item.endedAt == null ? '' : day.format(item.endedAt!),
      outcomeLabel?.call(item.outcome) ?? item.outcome.name,
      item.veterinarian ?? '',
      csvNumber(item.cost),
    ]);
  }

  return buildCsv(rows);
}

/// Прочерк вместо пустоты: пустая клетка на бумаге читается как «забыли
/// напечатать», прочерк — как «данных нет».
const _dash = '—';

/// Лист печатают на обычном чёрно-белом принтере, поэтому всё держится на
/// линиях и жирности, а не на цвете.
const _css = '''
@page { size: A4 portrait; margin: 12mm; }
/* Телефон часто в тёмной теме: без этого системный движок перекрашивает
   страницу и на бумагу уходит чёрный фон — картридж на один лист. */
:root { color-scheme: light; }
body { font-family: Arial, Helvetica, sans-serif; color: #000; background: #fff; margin: 0; }
h1 { font-size: 20pt; margin: 0 0 1mm; }
h2 { font-size: 14pt; margin: 6mm 0 2mm; text-transform: uppercase; }
.tag { font-size: 12pt; margin: 0 0 3mm; }
.facts { margin: 0 0 4mm; padding-left: 5mm; font-size: 11pt; }
.facts li { margin-bottom: 1mm; }
.empty { font-size: 11pt; font-style: italic; }
table { width: 100%; border-collapse: collapse; font-size: 11pt; }
thead { display: table-header-group; }
tr { page-break-inside: avoid; }
th, td { border: 1px solid #000; padding: 2mm; text-align: left; vertical-align: top; }
th { font-size: 10pt; text-transform: uppercase; }
.day { white-space: nowrap; }
.printed { font-size: 9pt; margin-top: 5mm; }
''';

/// Кличка и диагноз приходят из базы и могут содержать любой символ — без
/// экранирования одна такая строка развалила бы вёрстку листа.
String _esc(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
