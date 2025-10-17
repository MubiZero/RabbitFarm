import '../../data/models/pedigree_model.dart';

/// Сервис для анализа инбридинга (родственного скрещивания)
///
/// Анализирует родословную двух кроликов и вычисляет:
/// - Коэффициент инбридинга
/// - Общих предков
/// - Степень родства
class InbreedingAnalyzer {
  /// Вычислить коэффициент инбридинга между двумя кроликами
  ///
  /// Возвращает значение от 0.0 (не родственники) до 1.0 (полное родство)
  static InbreedingAnalysis analyze(
    PedigreeModel male,
    PedigreeModel female,
  ) {
    final commonAncestors = _findCommonAncestors(male, female);
    final coefficient = _calculateInbreedingCoefficient(male, female, commonAncestors);

    return InbreedingAnalysis(
      coefficient: coefficient,
      commonAncestors: commonAncestors,
      riskLevel: _getRiskLevel(coefficient),
      recommendations: _getRecommendations(coefficient, commonAncestors),
    );
  }

  /// Найти общих предков
  static List<CommonAncestor> _findCommonAncestors(
    PedigreeModel male,
    PedigreeModel female,
  ) {
    final maleAncestors = _collectAncestors(male, 1);
    final femaleAncestors = _collectAncestors(female, 1);

    final common = <CommonAncestor>[];

    for (var maleEntry in maleAncestors.entries) {
      if (femaleAncestors.containsKey(maleEntry.key)) {
        common.add(CommonAncestor(
          id: maleEntry.key,
          name: maleEntry.value.name,
          maleGeneration: maleEntry.value.generation,
          femaleGeneration: femaleAncestors[maleEntry.key]!.generation,
        ));
      }
    }

    return common;
  }

  /// Собрать всех предков с указанием поколения
  static Map<int, AncestorInfo> _collectAncestors(
    PedigreeModel rabbit,
    int generation,
  ) {
    final ancestors = <int, AncestorInfo>{};

    void traverse(PedigreeModel? current, int gen) {
      if (current == null || gen > 5) return; // Ограничиваем глубину до 5 поколений

      if (!ancestors.containsKey(current.id)) {
        ancestors[current.id] = AncestorInfo(
          name: current.name,
          generation: gen,
        );
      }

      traverse(current.father, gen + 1);
      traverse(current.mother, gen + 1);
    }

    // Не включаем самого кролика, только родителей
    traverse(rabbit.father, generation);
    traverse(rabbit.mother, generation);

    return ancestors;
  }

  /// Вычислить коэффициент инбридинга
  ///
  /// Упрощенная формула: сумма (1/2)^n для каждого общего предка,
  /// где n - сумма поколений до этого предка
  static double _calculateInbreedingCoefficient(
    PedigreeModel male,
    PedigreeModel female,
    List<CommonAncestor> commonAncestors,
  ) {
    if (commonAncestors.isEmpty) {
      return 0.0;
    }

    // Проверка прямого родства
    if (male.id == female.father?.id || male.id == female.mother?.id) {
      return 0.5; // Отец-дочь или обратно
    }
    if (female.id == male.father?.id || female.id == male.mother?.id) {
      return 0.5; // Мать-сын или обратно
    }

    // Проверка на полное сиблингство (брат-сестра)
    if (male.father?.id == female.father?.id &&
        male.mother?.id == female.mother?.id &&
        male.father != null && male.mother != null) {
      return 0.25; // Полные братья/сестры
    }

    // Вычисление для общих предков
    double coefficient = 0.0;

    for (var ancestor in commonAncestors) {
      final pathLength = ancestor.maleGeneration + ancestor.femaleGeneration;
      coefficient += 1.0 / (1 << pathLength); // 2^pathLength
    }

    return coefficient.clamp(0.0, 1.0);
  }

  /// Определить уровень риска
  static InbreedingRiskLevel _getRiskLevel(double coefficient) {
    if (coefficient >= 0.5) {
      return InbreedingRiskLevel.critical;
    } else if (coefficient >= 0.25) {
      return InbreedingRiskLevel.high;
    } else if (coefficient >= 0.125) {
      return InbreedingRiskLevel.medium;
    } else if (coefficient > 0.0) {
      return InbreedingRiskLevel.low;
    } else {
      return InbreedingRiskLevel.none;
    }
  }

  /// Получить рекомендации
  static List<String> _getRecommendations(
    double coefficient,
    List<CommonAncestor> commonAncestors,
  ) {
    final recommendations = <String>[];

    if (coefficient >= 0.5) {
      recommendations.add('⛔ Критический уровень родства! Скрещивание настоятельно не рекомендуется.');
      recommendations.add('Высокий риск генетических дефектов и проблем со здоровьем потомства.');
    } else if (coefficient >= 0.25) {
      recommendations.add('⚠️ Высокий уровень родства. Скрещивание не рекомендуется.');
      recommendations.add('Возможны генетические проблемы у потомства.');
      recommendations.add('Рассмотрите использование неродственных производителей.');
    } else if (coefficient >= 0.125) {
      recommendations.add('⚡ Средний уровень родства. Скрещивание допустимо с осторожностью.');
      recommendations.add('Рекомендуется тщательный отбор и контроль здоровья потомства.');
      recommendations.add('Желательно чередовать с неродственным разведением.');
    } else if (coefficient > 0.0) {
      recommendations.add('✓ Низкий уровень родства. Скрещивание допустимо.');
      recommendations.add('Общие предки находятся в дальних поколениях.');
    } else {
      recommendations.add('✓ Родство не обнаружено. Оптимально для разведения.');
      recommendations.add('Отсутствие общих предков снижает риск генетических проблем.');
    }

    if (commonAncestors.isNotEmpty) {
      recommendations.add('');
      recommendations.add('Общие предки: ${commonAncestors.map((a) => a.name).join(", ")}');
    }

    return recommendations;
  }
}

/// Результат анализа инбридинга
class InbreedingAnalysis {
  final double coefficient;
  final List<CommonAncestor> commonAncestors;
  final InbreedingRiskLevel riskLevel;
  final List<String> recommendations;

  InbreedingAnalysis({
    required this.coefficient,
    required this.commonAncestors,
    required this.riskLevel,
    required this.recommendations,
  });

  /// Получить процентное значение
  String get coefficientPercent => '${(coefficient * 100).toStringAsFixed(1)}%';

  /// Есть ли общие предки
  bool get hasCommonAncestors => commonAncestors.isNotEmpty;
}

/// Общий предок
class CommonAncestor {
  final int id;
  final String name;
  final int maleGeneration; // Поколение от самца
  final int femaleGeneration; // Поколение от самки

  CommonAncestor({
    required this.id,
    required this.name,
    required this.maleGeneration,
    required this.femaleGeneration,
  });

  /// Ближайшее поколение
  int get closestGeneration => maleGeneration < femaleGeneration ? maleGeneration : femaleGeneration;
}

/// Информация о предке
class AncestorInfo {
  final String name;
  final int generation;

  AncestorInfo({
    required this.name,
    required this.generation,
  });
}

/// Уровень риска инбридинга
enum InbreedingRiskLevel {
  none('Нет', 'Родство не обнаружено', 0xFF4CAF50), // Зеленый
  low('Низкий', 'Дальнее родство', 0xFF8BC34A), // Светло-зеленый
  medium('Средний', 'Умеренное родство', 0xFFFFC107), // Желтый
  high('Высокий', 'Близкое родство', 0xFFFF9800), // Оранжевый
  critical('Критический', 'Очень близкое родство', 0xFFF44336); // Красный

  final String label;
  final String description;
  final int colorValue;

  const InbreedingRiskLevel(this.label, this.description, this.colorValue);
}
