import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/features/tasks/data/repositories/tasks_repository.dart';

import '../support/fake_storage.dart';

/// Регрессия с боевого стенда (2026-09-13): экран задач падал с
/// «null is not a subtype of int» на любой ферме, включая пустую. Провайдер
/// читал из конверта ключ `pages`, которого там нет — сервер отдаёт
/// `totalPages`, — и приведение `null as int` роняло разбор ответа целиком.
class _TasksAdapter implements HttpClientAdapter {
  _TasksAdapter(this.body);

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

TasksRepository _repository(Map<String, dynamic> body) {
  final client = ApiClient(storage: FakeStorage());
  client.dio.httpClientAdapter = _TasksAdapter(body);
  return TasksRepository(client);
}

void main() {
  test('пустой список задач разбирается, а не падает', () async {
    final repository = _repository({
      'success': true,
      'message': 'ok',
      'data': {
        'items': <dynamic>[],
        'pagination': {'page': 1, 'limit': 20, 'total': 0, 'totalPages': 0}
      }
    });

    final result = await repository.getTasks(limit: 20);

    expect(result['tasks'], isEmpty);
    final page = result['pagination'] as PageInfo;
    expect(page.page, 1);
    expect(page.total, 0);
    expect(page.totalPages, 0);
    expect(page.hasMore, isFalse);
  });

  test('конверт с несколькими страницами даёт hasMore', () async {
    final repository = _repository({
      'success': true,
      'message': 'ok',
      'data': {
        'items': <dynamic>[],
        'pagination': {'page': 1, 'limit': 20, 'total': 45, 'totalPages': 3}
      }
    });

    final page = (await repository.getTasks(limit: 20))['pagination'] as PageInfo;

    expect(page.totalPages, 3);
    expect(page.hasMore, isTrue);
  });

  test('конверт без пагинации не роняет разбор', () async {
    // Так отвечают эндпоинты, отдающие список без страниц.
    final repository = _repository({
      'success': true,
      'message': 'ok',
      'data': <dynamic>[]
    });

    final result = await repository.getTasks();

    expect(result['tasks'], isEmpty);
    expect((result['pagination'] as PageInfo).page, 1);
  });
}
