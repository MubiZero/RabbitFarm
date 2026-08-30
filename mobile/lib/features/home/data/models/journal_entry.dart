/// Одна строка ленты записей.
///
/// Пять источников — кормление, лечение, прививки, закрытые задачи и заметки —
/// приводятся к общему виду, чтобы лента сортировалась по времени и рисовалась
/// одним виджетом. Готовых подписей здесь нет: они зависят от языка, а слой
/// данных о нём не знает. Хранятся только куски, из которых экран собирает
/// строку, — и [formArgs], с которыми открывается форма правки этой записи.
enum JournalKind {
  feeding,
  treatment,
  vaccination,
  task,
  note;

  /// Форма, в которой эту запись правят.
  String get formRoute => switch (this) {
        JournalKind.feeding => '/feeding-records/form',
        JournalKind.treatment => '/medical-records/form',
        JournalKind.vaccination => '/vaccinations/form',
        JournalKind.task => '/tasks/form',
        JournalKind.note => '/notes/form',
      };
}

class JournalEntry {
  /// Что именно записано: от вида зависят значок, цвет и форма правки.
  final JournalKind kind;

  /// Когда записано — по нему лента и сортируется.
  final DateTime at;

  /// Момент или календарная дата. Прививка и лечение датируются днём без
  /// времени, и показывать у них «00:00» значило бы придумывать час, которого
  /// в данных нет.
  final bool hasTime;

  /// Название корма, прививки, диагноз, заголовок задачи. `null` — если
  /// сервер не привёз связанную запись; подпись подберёт экран.
  final String? title;

  final String? rabbitName;
  final String? cageNumber;

  /// Кто записал.
  final String? author;

  /// Модель записи для формы правки — go_router передаёт её как `extra`.
  final Object formArgs;

  const JournalEntry({
    required this.kind,
    required this.at,
    required this.hasTime,
    required this.formArgs,
    this.title,
    this.rabbitName,
    this.cageNumber,
    this.author,
  });
}
