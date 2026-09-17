import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/health/data/repositories/medical_records_repository.dart';
import 'package:mobile/features/health/data/repositories/vaccinations_repository.dart';
import 'package:mobile/features/notifications/data/repositories/notifications_repository.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';

import '../support/fake_storage.dart';

/// Списки, которым добавили постраничность, обязаны видеть вторую страницу.
///
/// Разбор конверта писался в каждом репозитории заново, и четыре из них
/// читали `total_pages`, тогда как сервер пишет `totalPages`
/// (`utils/apiResponse.js`). Число страниц выходило единицей, `hasMore`
/// оставался ложным — постраничность была на месте и не работала ни разу.
/// Это тот же промах, на котором уже падал экран задач.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body);

  final Map<String, dynamic> body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiClient _client(List<dynamic> items) {
  final client = ApiClient(storage: FakeStorage());
  client.dio.httpClientAdapter = _Adapter({
    'success': true,
    'message': 'ok',
    'data': {
      'items': items,
      // Ровно то, что отдаёт сервер: три страницы по тридцать.
      'pagination': {'page': 1, 'limit': 30, 'total': 75, 'totalPages': 3}
    }
  });
  return client;
}

void main() {
  test('прививки знают про следующую страницу', () async {
    final page = await VaccinationsRepository(apiClient: _client(const []))
        .getVaccinations(limit: 30);

    expect(page.totalPages, 3);
    expect(page.total, 75);
    expect(page.page < page.totalPages, isTrue);
  });

  test('лечение знает про следующую страницу', () async {
    final page = await MedicalRecordsRepository(_client(const []))
        .getMedicalRecords(limit: 30);

    expect(page.totalPages, 3);
    expect(page.total, 75);
  });

  test('окролы знают про следующую страницу', () async {
    final page =
        await BirthsRepository(apiClient: _client(const [])).getBirths(limit: 30);

    expect(page.totalPages, 3);
    expect(page.total, 75);
  });

  test('уведомления знают про следующую страницу', () async {
    final page = await NotificationsRepository(_client(const [])).load(limit: 30);

    expect(page.totalPages, 3);
    expect(page.total, 75);
  });
}
