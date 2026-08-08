import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

class DioService {
  static const String _baseUrl = "https://shamsung.haderin.sy/api/v1";

  final StorageService _storage = StorageService();

  Dio _buildDio() {
    final token = _storage.getToken();
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      ),
    );
  }

  /// Returns an authorized Dio instance for use-cases that need FormData
  /// (e.g. multipart uploads). The caller sets Content-Type via FormData.
  Dio buildAuthorizedDio() {
    final token = _storage.getToken();
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Accept": "application/json",
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      ),
    );
  }

  /// GET
  Future<Response> getData(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    debugPrint(
      'GET $endpoint | queryParameters: ${queryParameters ?? {}} | token: ${_storage.getToken().isNotEmpty ? 'present' : 'missing'}',
    );
    return await _buildDio().get(
      endpoint,
      queryParameters: queryParameters,
    );
  }

  /// POST
  Future<Response> postData({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    debugPrint(
      'POST $endpoint | token: ${_storage.getToken().isNotEmpty ? "present" : "missing"}',
    );
    return await _buildDio().post(endpoint, data: data);
  }

  /// DELETE
  Future<Response> deleteData(String endpoint) async {
    debugPrint(
      'DELETE $endpoint | token: ${_storage.getToken().isNotEmpty ? "present" : "missing"}',
    );
    return await _buildDio().delete(endpoint);
  }

  /// POST with X-HTTP-Method-Override (for servers that block DELETE/PUT/PATCH)
  /// Laravel reads this header and treats the request as the specified method.
  Future<Response> postWithMethodOverride({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
  }) async {
    final token = _storage.getToken();
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-HTTP-Method-Override': method,
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );
    debugPrint(
      'POST(X-$method) $endpoint | token: ${token.isNotEmpty ? "present" : "missing"}',
    );
    return await dio.post(endpoint, data: data ?? {});
  }
}
