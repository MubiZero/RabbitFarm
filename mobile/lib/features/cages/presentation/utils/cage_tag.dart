import 'package:barcode/barcode.dart';

import '../../data/models/cage_model.dart';

/// Метка на клетку: что в ней закодировано и как её печатать.
///
/// Клетка — главный ориентир в крольчатнике: в неё смотрят, у неё стоят, о
/// ней спрашивают. Но чтобы открыть её в приложении, приходилось вспоминать
/// номер и искать его в списке из сорока строк — стоя в проходе, одной
/// рукой. Метка убирает этот шаг целиком: навёл камеру — открылась та самая
/// клетка.
///
/// Ссылка — наша схема `rabbitfarm://`, как и у приглашения по SMS: чужой
/// сканер по ней откроет приложение, а не сайт, которого у нас нет.
String cageTagPayload(int cageId) => 'rabbitfarm://cage/$cageId';

/// Идентификатор клетки из отсканированного кода. `null` — код не наш.
///
/// Разбирается мягко: в крольчатнике на клетках могут висеть и чужие
/// наклейки (от поставщика, из магазина), и наводить камеру на них человек
/// будет обязательно. Ответ «это не метка клетки» лучше, чем ошибка.
int? cageIdFromTag(String? raw) {
  if (raw == null) return null;
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || uri.scheme != 'rabbitfarm') return null;

  // `rabbitfarm://cage/12` разбирается как host=cage, path=/12.
  if (uri.host != 'cage') return null;
  final segment = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
  return int.tryParse(segment ?? '');
}

/// Лист меток для печати.
///
/// Собирается HTML, а не документ средствами пакета `pdf`: встроенные в него
/// шрифты не содержат кириллицы, а номера клеток на фермах пишут по-русски
/// («Ряд А-3»). HTML рендерит сама платформа, и с любым алфавитом это
/// работает без бандла шрифтов.
///
/// Сам код рисуется в SVG прямо в разметку — картинку негде хранить, а
/// внешние ссылки на печати всё равно не загрузятся.
String cageTagsHtml(List<CageModel> cages, {required String hint}) {
  final labels = StringBuffer();

  for (final cage in cages) {
    final svg = Barcode.qrCode().toSvg(
      cageTagPayload(cage.id),
      width: 150,
      height: 150,
      drawText: false,
    );

    labels.write('''
    <div class="tag">
      $svg
      <div class="number">${_escape(cage.number)}</div>
      ${cage.location == null ? '' : '<div class="place">${_escape(cage.location!)}</div>'}
    </div>''');
  }

  return '''
<!DOCTYPE html>
<html><head><meta charset="utf-8"><style>
  @page { margin: 10mm; }
  body { font-family: sans-serif; margin: 0; }
  .hint { font-size: 11pt; color: #444; margin-bottom: 6mm; }
  .sheet { display: flex; flex-wrap: wrap; gap: 6mm; }
  /* Метка режется ножницами по рамке и вешается на клетку, поэтому рамка
     видимая, а не декоративная. */
  .tag {
    border: 1px dashed #999;
    padding: 4mm;
    width: 45mm;
    text-align: center;
    page-break-inside: avoid;
  }
  .tag svg { width: 35mm; height: 35mm; }
  .number { font-size: 16pt; font-weight: 700; margin-top: 2mm; }
  .place { font-size: 10pt; color: #555; }
</style></head>
<body>
  <div class="hint">${_escape(hint)}</div>
  <div class="sheet">$labels</div>
</body></html>''';
}

String _escape(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');
