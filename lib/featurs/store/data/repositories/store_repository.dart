import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';
import '../models/accessory_model.dart';
import '../models/cart_item_model.dart';
import '../models/checkout_model.dart';

class StoreRepository {
  final DioService _dioService = DioService();
  final StorageService _storage = StorageService();

  // ── GET /accessories ──────────────────────────────────────────────────────
  Future<List<AccessoryModel>> getAllAccessories({String? lang}) async {
    try {
      // StorageService هو المصدر الموثوق للغة — لا يعتمد على Get.locale
      final String effectiveLang = lang ?? _storage.getLanguage();
      final Response response = await _dioService.getData(
        '/accessories',
        queryParameters: {'lang': effectiveLang},
      );
      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map) {
          final outer = raw['data'];
          if (outer is Map && outer['data'] is List) {
            return (outer['data'] as List)
                .map((e) => AccessoryModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (outer is List) {
            return outer
                .map((e) => AccessoryModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
        if (raw is List) {
          return raw
              .map((e) => AccessoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── GET /accessories/{id} ─────────────────────────────────────────────────
  Future<AccessoryModel> getAccessoryDetails(int id) async {
    try {
      final Response response = await _dioService.getData('/accessories/$id');
      if (response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map && raw['data'] is Map<String, dynamic>) {
          return AccessoryModel.fromJson(raw['data'] as Map<String, dynamic>);
        }
        throw Exception('تعذر قراءة بيانات المنتج.');
      }
      throw Exception('حدث خطأ غير متوقع.');
    } on DioException catch (e) {
      throw _handleError(e, isDetails: true);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── GET /cart ─────────────────────────────────────────────────────────────
  Future<List<CartItemModel>> getCart() async {
    try {
      final Response response = await _dioService.getData('/cart');
      if (response.statusCode == 200) {
        final raw = response.data;
        List<dynamic>? list;
        if (raw is Map) {
          final d = raw['data'];
          if (d is List) list = d;
        } else if (raw is List) {
          list = raw;
        }
        return (list ?? []).map((e) {
          final json = e as Map<String, dynamic>;
          final accessoryJson =
              json['accessory'] as Map<String, dynamic>? ?? {};
          final accessory = AccessoryModel(
            id: accessoryJson['id'] ?? 0,
            shopId: 0,
            name: accessoryJson['name'] ?? '',
            description: '',
            price: double.tryParse(accessoryJson['price'].toString()) ?? 0.0,
            stockQuantity: 0,
            isActive: true,
            imageUrl: accessoryJson['image_url'] ?? '',
            createdAt: '',
          );
          return CartItemModel(
            cartItemId: json['id'] ?? 0,
            accessory: accessory,
            quantity: json['quantity'] ?? 1,
          );
        }).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── POST /cart ────────────────────────────────────────────────────────────
  Future<CartResponseModel> addToCart({
    required int accessoryId,
    required int quantity,
  }) async {
    try {
      final Response response = await _dioService.postData(
        endpoint: '/cart',
        data: {'accessory_id': accessoryId, 'quantity': quantity},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map<String, dynamic>) {
          return CartResponseModel.fromJson(raw);
        }
        throw Exception('تعذر قراءة بيانات السلة.');
      }
      throw Exception('حدث خطأ غير متوقع.');
    } on DioException catch (e) {
      throw _handleError(e, isCart: true);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── DELETE /cart/{id} ─────────────────────────────────────────────────────
  // The web server (Apache/Nginx) blocks pure DELETE requests with 403.
  // Solution: send POST with X-HTTP-Method-Override: DELETE header.
  // Laravel supports this via method spoofing.
  Future<void> deleteCartItem(int cartItemId) async {
    try {
      final Response response = await _dioService.postWithMethodOverride(
        endpoint: '/cart/$cartItemId',
        method: 'DELETE',
      );
      if (response.statusCode == 200) return;
      throw Exception('حدث خطأ غير متوقع.');
    } on DioException catch (e) {
      throw _handleError(e, isDeleteCart: true);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── POST /checkout ────────────────────────────────────────────────────────
  /// [paymentMethod] must be either "cash_on_delivery" or "pay_after_service"
  Future<CheckoutResponseModel> checkout({
    required String paymentMethod,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final Response response = await _dioService.postData(
        endpoint: '/checkout',
        data: {
          'payment_method': paymentMethod,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final raw = response.data;
        if (raw is Map<String, dynamic>) {
          return CheckoutResponseModel.fromJson(raw);
        }
        throw Exception('تعذر قراءة بيانات الطلب.');
      }
      throw Exception('حدث خطأ غير متوقع.');
    } on DioException catch (e) {
      throw _handleError(e, isCheckout: true);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('حدث خطأ: $e');
    }
  }

  // ── Error handler ─────────────────────────────────────────────────────────
  Exception _handleError(
    DioException e, {
    bool isDetails = false,
    bool isCart = false,
    bool isDeleteCart = false,
    bool isCheckout = false,
  }) {
    final code = e.response?.statusCode;
    String? msg;
    try {
      final body = e.response?.data;
      if (body is Map) msg = body['message']?.toString();
    } catch (_) {}

    if (code == 400 && isCart) {
      return Exception(msg ?? 'المنتج غير متاح أو الكمية المطلوبة غير كافية.');
    } else if (code == 400 && isCheckout) {
      return Exception(msg ?? 'السلة فارغة، أضف منتجات أولاً.');
    } else if (code == 401) {
      return Exception('غير مصرح: يرجى تسجيل الدخول مجدداً.');
    } else if (code == 403) {
      return Exception('ليس لديك صلاحية للوصول.');
    } else if (code == 404) {
      if (isDeleteCart) return Exception('العنصر غير موجود في السلة.');
      return isDetails
          ? Exception('المنتج غير موجود.')
          : Exception('لم يتم العثور على البيانات.');
    } else if (code == 422) {
      // Extract first validation error message if available
      try {
        final body = e.response?.data;
        if (body is Map) {
          final errors = body['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstField = errors.values.first;
            if (firstField is List && firstField.isNotEmpty) {
              return Exception(firstField.first.toString());
            }
          }
        }
      } catch (_) {}
      return Exception(msg ?? 'بيانات غير صالحة.');
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
