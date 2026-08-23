import '../../data/models/pedigree_model.dart';

/// Сервис для анализа инбридинга (родственного скрещивания)
///
/// Анализирует родословную двух кроликов и вычисляет:
/// - Коэффициент инбридинга
/// - Общих предков
/// - Степень родства
class InbreedingAnalyzer {
  /// Максимальная глубина обхода родословной.
  static const _maxGeneration = 5;

  /// Проанализировать пару перед случкой.
  ///
  /// Возвращает коэффициент инбридинга **будущего потомства**: 0.0 —
  /// неродственная пара, 0.25 — родитель с потомком или полные брат с сестрой.
  static InbreedingAnalysis analyze(
    PedigreeModel male,
    PedigreeModel female,
  ) {
    final commonAncestors = _findCommonAncestors(male, female);
    final coefficient = _kinship(male, female, {}, 0);

    return InbreedingAnalysis(
      coefficient: coefficient,
      commonAncestors: commonAncestors,
      riskLevel: _getRiskLevel(coefficient),
      recommendations: _getRecommendations(coefficient, commonAncestors),
    );
  }

  /// Коэффициент родства пары — он же коэффициент инбридинга их потомства.
  ///
  /// Считается по рекуррентному соотношению:
  ///   f(x, x) = 1/2
  ///   f(x, y) = ( f(отец x, y) + f(мать x, y) ) / 2, если предки x известны
  ///   f(x, y) = 0, если предки неизвестны
  ///
  /// Раньше здесь была прямая сумма (1/2)^(поколение самца + поколение самки)
  /// с отдельными случаями «родитель-потомок» и «полные сибсы». В формуле
  /// Райта не хватало единицы в показателе, поэтому все значения выходили
  /// вдвое больше настоящих: полусибсы получали те же 25%, что и полные
  /// сибсы, — то есть инструмент не различал ровно те две вязки, которые
  /// заводчику важнее всего различать. Верное число давала только зашитая
  /// ветка про полных сибсов, и она же прятала ошибку.
  ///
  /// Рекуррентная форма считает все пути сразу и не нуждается в частных
  /// случаях: и родитель с потомком, и полные сибсы дают 0.25 сами собой.
  static double _kinship(
    PedigreeModel? x,
    PedigreeModel? y,
    Map<String, double> memo,
    int depth,
  ) {
    if (x == null || y == null || depth > _maxGeneration * 2) return 0.0;

    // Один и тот же кролик: половина его генов совпадает сама с собой.
    if (x.id == y.id) return 0.5;

    final key = x.id < y.id ? '${x.id}:${y.id}' : '${y.id}:${x.id}';
    final cached = memo[key];
    if (cached != null) return cached;

    // Спускаться нужно от младшего: иначе родство деда с внуком посчитается
    // так, будто внук — предок деда.
    final younger = _younger(x, y);
    final other = identical(younger, x) ? y : x;

    final result = (younger.father == null && younger.mother == null)
        ? 0.0
        : (_kinship(younger.father, other, memo, depth + 1) +
                _kinship(younger.mother, other, memo, depth + 1)) /
            2;

    memo[key] = result;
    return result;
  }

  /// Кто из двоих младше.
  ///
  /// По дате рождения, если она известна у обоих; иначе младшим считаем того,
  /// чьи родители известны — подниматься по родословной можно только от него.
  static PedigreeModel _younger(PedigreeModel a, PedigreeModel b) {
    final aBorn = DateTime.tryParse(a.birthDate ?? '');
    final bBorn = DateTime.tryParse(b.birthDate ?? '');

    if (aBorn != null && bBorn != null && aBorn != bBorn) {
      return aBorn.isAfter(bBorn) ? a : b;
    }

    final aHasParents = a.father != null || a.mother != null;
    final bHasParents = b.father != null || b.mother != null;

    if (aHasParents != bHasParents) return aHasParents ? a : b;
    return a;
  }

  /// Найти общих предков — для показа в интерфейсе.
  static List<CommonAncestor> _findCommonAncestors(
    PedigreeModel male,
    PedigreeModel female,
  ) {
    final maleAncestors = _collectAncestors(male);
    final femaleAncestors = _collectAncestors(female);

    final common = <CommonAncestor>[];

    for (final maleEntry in maleAncestors.entries) {
      final femaleAncestor = femaleAncestors[maleEntry.key];
      if (femaleAncestor != null) {
        common.add(CommonAncestor(
          id: maleEntry.key,
          name: maleEntry.value.name,
          maleGeneration: maleEntry.value.generation,
          femaleGeneration: femaleAncestor.generation,
        ));
      }
    }

    return common;
  }

  /// Собрать предков с номером ближайшего поколения.
  ///
  /// Сам кролик тоже попадает в список нулевым поколением: иначе пара
  /// «отец и дочь» не имела бы общих предков вовсе, если родители отца
  /// неизвестны, — а это обычное дело для покупного производителя.
  static Map<int, AncestorInfo> _collectAncestors(PedigreeModel rabbit) {
    final ancestors = <int, AncestorInfo>{};

    void traverse(PedigreeModel? current, int generation) {
      if (current == null || generation > _maxGeneration) return;

      final known = ancestors[current.id];
      // Ближайшее поколение, а не первое найденное: обход идёт сначала по
      // отцовской линии, и предок из её глубины иначе записывался бы дальним,
      // хотя по материнской линии он совсем близкий.
      if (known == null || generation < known.generation) {
        ancestors[current.id] = AncestorInfo(
          name: current.name,
          generation: generation,
        );
      } else {
        return;
      }

      traverse(current.father, generation + 1);
      traverse(current.mother, generation + 1);
    }

    traverse(rabbit, 0);

    return ancestors;
  }

  /// Уровень риска по коэффициенту инбридинга потомства.
  ///
  /// Пороги соответствуют реальным значениям: 0.25 — родитель с потомком или
  /// полные сибсы, 0.125 — полусибсы, 0.0625 — двоюродные.
  static InbreedingRiskLevel _getRiskLevel(double coefficient) {
    if (coefficient >= 0.25) {
      return InbreedingRiskLevel.critical;
    } else if (coefficient >= 0.125) {
      return InbreedingRiskLevel.high;
    } else if (coefficient >= 0.0625) {
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

    if (coefficient >= 0.25) {
      recommendations.add('⛔ Критический уровень родства! Скрещивание настоятельно не рекомендуется.');
      recommendations.add('Так близки родитель с потомком или полные брат с сестрой.');
      recommendations.add('Высокий риск генетических дефектов и проблем со здоровьем потомства.');
    } else if (coefficient >= 0.125) {
      recommendations.add('⚠️ Высокий уровень родства. Скрещивание не рекомендуется.');
      recommendations.add('Так близки полубрат с полусестрой или дядя с племянницей.');
      recommendations.add('Рассмотрите использование неродственных производителей.');
    } else if (coefficient >= 0.0625) {
      recommendations.add('⚡ Средний уровень родства. Скрещивание допустимо с осторожностью.');
      recommendations.add('Примерно так близки двоюродные.');
      recommendations.add('Рекомендуется тщательный отбор и контроль здоровья потомства.');
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
