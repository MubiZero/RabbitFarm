import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/json/int_converter.dart';

void main() {
  group('IntConverter', () {
    test('parses num to int', () {
      const converter = IntConverter();
      expect(converter.fromJson(3.7), 3);
      expect(converter.fromJson(3), 3);
    });

    test('parses String to int', () {
      const converter = IntConverter();
      expect(converter.fromJson('42'), 42);
    });

    test('toJson returns same int', () {
      const converter = IntConverter();
      expect(converter.toJson(7), 7);
    });

    test('throws on invalid input', () {
      const converter = IntConverter();
      expect(() => converter.fromJson(Object()), throwsArgumentError);
      expect(() => converter.fromJson('abc'), throwsA(isA<FormatException>()));
    });
  });
}