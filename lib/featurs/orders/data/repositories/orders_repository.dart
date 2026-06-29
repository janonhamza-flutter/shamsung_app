import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../models/order_model.dart';

class OrdersRepository {
  final DioService _dioService = DioService();

  // ── GET /orders ───────────────────────────────────────────────────────────
  Future<OrdersResponseModel> getMyOrders() async {
    try {
      final Response response = await _dioService.getData('/orders');
      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map<String, dynamic>) {
          return OrdersResponseModel.fromJson(raw);
        }
        if (raw is List) {
          final orders = raw
              .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList();
          return OrdersResponseModel(message: '', orders: orders);
        }
        throw Exception('تعذر قراءة بيانات الطلبات.');
      }
      throw Exception('حدث خطأ غير متوقع.');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── Error handler ─────────────────────────────────────────────────────────
  Exception _handleError(DioException e) {
    final code = e.response?.statusCode;
    String? msg;
    try {
      final body = e.response?.data;
      if (body is Map) msg = body['message']?.toString();
    } catch (_) {}

    if (code == 401) {
      return Exception('غير مصرح: يرجى تسجيل الدخول مجدداً.');
    } else if (code == 403) {
      return Exception('ليس لديك صلاحية للوصول.');
    } else if (code == 404) {
      return Exception('لم يتم العثور على الطلبات.');
    } else if (code == 500) {
      return Exception('خطأ في الخادم، يرجى المحاولة لاحقاً.');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('انتهت مهلة الاتصال، تحقق من اتصالك بالإنترنت.');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت.');
    } else {
      return Exception(msg ?? 'حدث خطأ غير متوقع: ${e.message}');
    }
  }
}
