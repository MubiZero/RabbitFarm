/// Официальный телефон и почта поддержки — один набор на весь сервис.
///
/// Лежит в core, а не в фиче: ферма их читает на экране поддержки,
/// платформенный админ — правит в админке, и разбирать один и тот же ответ
/// сервера двумя разными классами было бы поводом для расхождений.
///
/// Пустые поля — норма, а не ошибка: контакт может быть ещё не задан.
class SupportContact {
  final String? email;
  final String? phone;

  const SupportContact({this.email, this.phone});

  bool get isEmpty => email == null && phone == null;

  factory SupportContact.fromJson(Map<String, dynamic> json) => SupportContact(
    email: _trimmed(json['email']),
    phone: _trimmed(json['phone']),
  );

  /// Пустая строка уходит на сервер именно как пустая, а не пропускается:
  /// «стереть телефон» — такое же изменение, как «вписать новый».
  Map<String, dynamic> toJson() => {'email': email ?? '', 'phone': phone ?? ''};

  /// Пробелы по краям и пустая строка — это «не задано»: иначе на экране
  /// фермы появлялась бы нажимаемая строка, ведущая в никуда.
  static String? _trimmed(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
