/// Models for GET /customer/deliveries response.
library;

class DeliveryWorkerModel {
  final int id;
  final String firstName;
  final String lastName;

  DeliveryWorkerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName {
    final parts = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).toList();
    return parts.join(' ').trim();
  }

  factory DeliveryWorkerModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name']?.toString() ?? '';
    final lastName = json['last_name']?.toString() ?? '';
    final fallbackName = json['name']?.toString() ?? '';

    return DeliveryWorkerModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      firstName: firstName.isNotEmpty
          ? firstName
          : (fallbackName.isNotEmpty ? fallbackName : ''),
      lastName: lastName,
    );
  }
}

class DeliveryShopModel {
  final int id;
  final String name;
  final String address;

  DeliveryShopModel({
    required this.id,
    required this.name,
    required this.address,
  });

  factory DeliveryShopModel.fromJson(Map<String, dynamic> json) {
    return DeliveryShopModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}

class DeliveryModel {
  final int id;
  final String type;
  final String status;
  final String? estimatedTime;
  final String paymentMethod;
  final int? orderId;
  final String? address;
  final String? notes;
  final DeliveryWorkerModel? deliveryWorker;
  final DeliveryShopModel? shop;
  final String? confirmationCode;
  final String createdAt;

  DeliveryModel({
    required this.id,
    required this.type,
    required this.status,
    this.estimatedTime,
    required this.paymentMethod,
    this.orderId,
    this.address,
    this.notes,
    this.deliveryWorker,
    this.shop,
    required this.createdAt,
    this.confirmationCode,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    // تحويل آمن لأي Map بغض النظر عن نوع المفاتيح
    Map<String, dynamic>? safeMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), v));
      }
      return null;
    }

    final workerMap = safeMap(json['delivery_worker']);
    final shopMap = safeMap(json['shop']);

    return DeliveryModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      estimatedTime: json['estimated_time']?.toString(),
      paymentMethod: json['payment_method']?.toString() ?? '',
      orderId: int.tryParse(json['order_id']?.toString() ?? ''),
      address: json['address']?.toString(),
      notes: json['notes']?.toString(),
      deliveryWorker: workerMap != null
          ? DeliveryWorkerModel.fromJson(workerMap)
          : null,
      shop: shopMap != null ? DeliveryShopModel.fromJson(shopMap) : null,
      confirmationCode:
          json['confirmation_code']?.toString() ??
          json['confirmation']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class DeliveriesResponseModel {
  final String message;
  final List<DeliveryModel> deliveries;

  DeliveriesResponseModel({required this.message, required this.deliveries});

  factory DeliveriesResponseModel.fromJson(Map<String, dynamic> json) {
    // تحويل آمن لأي Map
    Map<String, dynamic> toStringMap(Map m) =>
        m.map((k, v) => MapEntry(k.toString(), v));

    List<DeliveryModel> extract(dynamic field) {
      if (field == null) return [];

      if (field is List) {
        return field.map((e) {
          final map = e is Map<String, dynamic> ? e : toStringMap(e as Map);
          return DeliveryModel.fromJson(map);
        }).toList();
      }

      if (field is Map) {
        final inner = field['data'];
        if (inner is List) {
          return inner.map((e) {
            final map = e is Map<String, dynamic> ? e : toStringMap(e as Map);
            return DeliveryModel.fromJson(map);
          }).toList();
        }
      }
      return [];
    }

    return DeliveriesResponseModel(
      message: json['message']?.toString() ?? '',
      deliveries: extract(json['data'] ?? json['deliveries']),
    );
  }
}
