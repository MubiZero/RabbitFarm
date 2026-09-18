import 'dart:convert';

import 'package:share_plus/share_plus.dart';

/// Отдать таблицу наружу — в почту, мессенджер или «Файлы».
///
/// Печать закрывает бумагу: её носят ветеринару и в банк. Но половина
/// хозяйств пришла с Excel и считает там своё, а распечатанный лист обратно
/// в таблицу не превратишь — поэтому рядом с печатью всегда стоит файл.
///
/// Одна точка на всё приложение, как и у печати (`core/printing`): иначе
/// способ сохранить файл пришлось бы повторять в каждом месте выгрузки.
///
/// Файл уходит из памяти, без временной папки: выгрузки здесь на сотни
/// строк, и оставлять после себя мусор на переполненном телефоне незачем.
Future<void> shareCsvFile({
  required String csv,
  required String fileName,
  required String subject,
}) async {
  final file = XFile.fromData(
    // utf8, а не `Utf8Codec` по умолчанию у `XFile.fromData`: BOM внутри
    // строки должен доехать до файла ровно тем байтом, ради которого он там
    // стоит (см. `core/export/csv.dart`).
    utf8.encode(csv),
    mimeType: 'text/csv',
    name: '$fileName.csv',
  );

  await SharePlus.instance.share(
    ShareParams(files: [file], subject: subject, fileNameOverrides: ['$fileName.csv']),
  );
}
