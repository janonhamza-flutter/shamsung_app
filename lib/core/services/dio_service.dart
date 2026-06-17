import 'package:dio/dio.dart';

import 'storage_service.dart';

class DioService {
  late Dio dio;
  final StorageService storage = StorageService();
  DioService() {
    print("TOKEN = ${storage.getToken()}");
    // انشاء اوبجكت من dio بدير كل الاتصالات بالسيرفر
    dio = Dio(
      // اعدادت عامة لكل requests
      BaseOptions(
        baseUrl: "https://shamsung.haderin.sy/api/v1",

        // السيرفر اذا ما استجاب خلال 10 ثوان بوقف ويعطي error
        connectTimeout: const Duration(seconds: 30),

        // ينتظر وصول البيانات
        receiveTimeout: const Duration(seconds: 30),

        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${storage.getToken()}",
        },
      ),
    );
  }

  /// =========================
  /// GET
  /// =========================

  Future<Response> getData(String endpoint) async {
    return await dio.get(endpoint);
  }

  /// =========================
  /// POST
  /// =========================

  Future<Response> postData({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(endpoint, data: data);
  }
}
