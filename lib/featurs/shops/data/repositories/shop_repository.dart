import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../models/shop_model.dart';

class ShopRepository {
  final DioService _dio = DioService();

  /// POST /shops/nearest  — يرسل latitude + longitude ويعيد قائمة أقرب المحلات
  Future<List<ShopModel>> findNearest({
    required double latitude,
    required double longitude,
  }) async {
    final Response response = await _dio.postData(
      endpoint: '/shops/nearest',
      data: {'latitude': latitude, 'longitude': longitude},
    );

    final List<dynamic> raw = response.data['data'] as List<dynamic>;
    return raw
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
