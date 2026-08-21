import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/rabbits/data/models/pedigree_model.dart';
import 'package:mobile/features/rabbits/domain/services/inbreeding_analyzer.dart';

PedigreeModel rabbit(
  int id,
  String name, {
  required String born,
  String sex = 'unknown',
  PedigreeModel? father,
  PedigreeModel? mother,
}) =>
    PedigreeModel(
      id: id,
      name: name,
      sex: sex,
      birthDate: born,
      father: father,
      mother: mother,
    );

void main() {
  group('Коэффициент инбридинга потомства', () {
    test('неродственная пара — ноль', () {
      final male = rabbit(1, 'Самец', born: '2024-01-01', sex: 'male');
      final female = rabbit(2, 'Самка', born: '2024-01-01', sex: 'female');

      final analysis = InbreedingAnalyzer.analyze(male, female);

      expect(analysis.coefficient, 0.0);
      expect(analysis.riskLevel, InbreedingRiskLevel.none);
    });

    // Главная регрессия: проверка «нет общих предков» стояла выше проверки
    // прямого родства, поэтому при неизвестных родителях самца пара
    // «отец и дочь» получала вердикт «Оптимально для разведения».
    test('отец и дочь — 25%, даже когда родители отца неизвестны', () {
      final father = rabbit(1, 'Отец', born: '2020-03-01', sex: 'male');
      final daughter = rabbit(2, 'Дочь',
          born: '2023-05-01', sex: 'female', father: father);

      final analysis = InbreedingAnalyzer.analyze(father, daughter);

      expect(analysis.coefficient, closeTo(0.25, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.critical);
      expect(analysis.hasCommonAncestors, isTrue);
    });

    test('мать и сын — тоже 25%', () {
      final mother = rabbit(1, 'Мать', born: '2020-03-01', sex: 'female');
      final son = rabbit(2, 'Сын',
          born: '2023-05-01', sex: 'male', mother: mother);

      final analysis = InbreedingAnalyzer.analyze(son, mother);

      expect(analysis.coefficient, closeTo(0.25, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.critical);
    });

    test('полные брат и сестра — 25%', () {
      final sire = rabbit(10, 'Общий отец', born: '2019-01-01', sex: 'male');
      final dam = rabbit(11, 'Общая мать', born: '2019-01-01', sex: 'female');

      final brother = rabbit(1, 'Брат',
          born: '2022-01-01', sex: 'male', father: sire, mother: dam);
      final sister = rabbit(2, 'Сестра',
          born: '2022-01-01', sex: 'female', father: sire, mother: dam);

      final analysis = InbreedingAnalyzer.analyze(brother, sister);

      expect(analysis.coefficient, closeTo(0.25, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.critical);
    });

    // Раньше полусибсы получали те же 25%, что и полные, — инструмент не
    // различал две вязки, которые заводчику важнее всего различать.
    test('полубрат и полусестра — 12.5%, вдвое меньше полных сибсов', () {
      final sire = rabbit(10, 'Общий отец', born: '2019-01-01', sex: 'male');
      final dam1 = rabbit(11, 'Мать первого', born: '2019-01-01', sex: 'female');
      final dam2 = rabbit(12, 'Мать второй', born: '2019-01-01', sex: 'female');

      final brother = rabbit(1, 'Полубрат',
          born: '2022-01-01', sex: 'male', father: sire, mother: dam1);
      final sister = rabbit(2, 'Полусестра',
          born: '2022-01-01', sex: 'female', father: sire, mother: dam2);

      final analysis = InbreedingAnalyzer.analyze(brother, sister);

      expect(analysis.coefficient, closeTo(0.125, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.high);
    });

    test('двоюродные — 6.25%', () {
      final grandSire = rabbit(20, 'Дед', born: '2017-01-01', sex: 'male');
      final grandDam = rabbit(21, 'Бабка', born: '2017-01-01', sex: 'female');

      final parentOne = rabbit(10, 'Отец первого',
          born: '2020-01-01', sex: 'male', father: grandSire, mother: grandDam);
      final parentTwo = rabbit(11, 'Отец второй',
          born: '2020-01-01', sex: 'male', father: grandSire, mother: grandDam);

      final male = rabbit(1, 'Кузен',
          born: '2023-01-01',
          sex: 'male',
          father: parentOne,
          mother: rabbit(12, 'Мать кузена', born: '2020-06-01'));
      final female = rabbit(2, 'Кузина',
          born: '2023-01-01',
          sex: 'female',
          father: parentTwo,
          mother: rabbit(13, 'Мать кузины', born: '2020-06-01'));

      final analysis = InbreedingAnalyzer.analyze(male, female);

      expect(analysis.coefficient, closeTo(0.0625, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.medium);
    });

    test('дед и внучка — 12.5%', () {
      final grandSire = rabbit(10, 'Дед', born: '2018-01-01', sex: 'male');
      final father = rabbit(11, 'Отец',
          born: '2021-01-01', sex: 'male', father: grandSire);
      final granddaughter = rabbit(1, 'Внучка',
          born: '2024-01-01', sex: 'female', father: father);

      final analysis = InbreedingAnalyzer.analyze(grandSire, granddaughter);

      expect(analysis.coefficient, closeTo(0.125, 1e-9));
      expect(analysis.riskLevel, InbreedingRiskLevel.high);
    });

    test('общий предок засчитывается по ближайшей линии', () {
      // Предок стоит глубоко по отцовской линии самца и близко по материнской.
      // Обход идёт сначала по отцу, поэтому раньше записывалось дальнее
      // поколение и родство выглядело более далёким, чем есть.
      final ancestor = rabbit(50, 'Общий предок', born: '2015-01-01');

      final deepLine =
          rabbit(41, 'Прадед', born: '2017-01-01', father: ancestor);
      final deeper =
          rabbit(40, 'Дед по отцу', born: '2019-01-01', father: deepLine);

      final male = rabbit(1, 'Самец',
          born: '2023-01-01',
          sex: 'male',
          father: rabbit(30, 'Отец самца', born: '2021-01-01', father: deeper),
          mother:
              rabbit(31, 'Мать самца', born: '2021-01-01', father: ancestor));

      final female = rabbit(2, 'Самка',
          born: '2023-01-01', sex: 'female', father: ancestor);

      final analysis = InbreedingAnalyzer.analyze(male, female);

      final common = analysis.commonAncestors.firstWhere((a) => a.id == 50);
      expect(common.maleGeneration, 2,
          reason: 'ближайший путь — через мать, а не через отцовскую линию');
    });
  });
}
