/// Тариф, каким его видит покупатель.
///
/// Различаются тарифы ровно тремя вещами: сколько кроликов можно вести,
/// сколько работников пустить в приложение и сколько это стоит. `null` в
/// пределах — «без ограничения», `null` в цене — «цену называет поддержка».
class PlanOption {
  const PlanOption({
    required this.id,
    required this.name,
    this.maxRabbits,
    this.maxStaff,
    this.price,
  });

  final int id;
  final String name;
  final int? maxRabbits;
  final int? maxStaff;
  final double? price;

  bool get isFree => price == null || price == 0;

  factory PlanOption.fromJson(Map<String, dynamic> json) => PlanOption(
        id: json['id'] as int,
        name: json['name'] as String,
        maxRabbits: json['max_rabbits'] as int?,
        maxStaff: json['max_staff'] as int?,
        price: (json['price'] as num?)?.toDouble(),
      );
}
