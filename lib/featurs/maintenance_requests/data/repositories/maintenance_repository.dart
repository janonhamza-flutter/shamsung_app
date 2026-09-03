import '../../../../core/services/dio_service.dart';
import '../../../shops/data/models/shop_model.dart';

class MaintenanceRepository {
  final DioService dioService = DioService();

  Future createRequest({
    required int shopId,
    required String deviceModel,
    required String problemDescription,
    required double latitude,
    required double longitude,
  }) async {
    return await dioService.postData(
      endpoint: "/maintenance-requests",
      data: {
        "shop_id": shopId,
        "device_model": deviceModel,
        "problem_description": problemDescription,
        "latitude": latitude,
        "longitude": longitude,
      },
    );
  }

  /// جلب جميع المتاجر عبر nearest shops بموقع مركز دمشق كافتراضي
  Future<List<ShopModel>> getAllShops() async {
    final response = await dioService.postData(
      endpoint: '/shops/nearest',
      data: {'latitude': 33.5138, 'longitude': 36.2765},
    );
    final List<dynamic> raw = response.data['data'] as List<dynamic>;
    return raw
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
