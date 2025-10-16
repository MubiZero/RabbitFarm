import 'package:dio/dio.dart';

class BreedsApi {
  final Dio _dio;

  BreedsApi(Dio dio) : _dio = dio;

  Future<Response> getBreeds() {
    return _dio.get('/breeds');
  }
}
