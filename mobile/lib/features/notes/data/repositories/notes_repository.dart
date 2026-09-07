import 'package:dio/dio.dart';
import '../../../../core/api/paginated.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_failure.dart';
import '../models/note_model.dart';

/// Заметки: по кролику, по клетке или по ферме в целом.
class NotesRepository {
  final ApiClient _apiClient;

  NotesRepository(this._apiClient);

  Future<List<NoteModel>> getNotes({int? limit}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.notes,
        queryParameters: {if (limit != null) 'limit': limit},
      );

      return [
        for (final item in itemsOf(response.data['data']))
          NoteModel.fromJson(item as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<NoteModel> getNoteById(int id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.notes}/$id');
      return NoteModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<NoteModel> createNote(NoteCreate note) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.notes,
        data: note.toJson(),
      );
      return NoteModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<NoteModel> updateNote(int id, NoteUpdate note) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.notes}/$id',
        data: note.toJson(),
      );
      return NoteModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.notes}/$id');
    } on DioException catch (e) {
      throw ApiFailure.from(e);
    }
  }
}
