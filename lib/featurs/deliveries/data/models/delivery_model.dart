/// Models for GET /customer/deliveries response.
library;

class DeliveryWorkerModel {
  final String name;

  DeliveryWorkerModel({required this.name});

  factory DeliveryWorkerModel.fromJson(Map<String, dynamic> json) {
    return DeliveryWorkerModel(name: json['name']?.toString() ?? '');
  }
}

class DeliveryShopModel {
  final int id;
  final String name;

  DeliveryShopModel({required this.id, required this.name});

  factory DeliveryShopModel.fromJson(Map<String, dynamic> json) {
    return DeliveryShopModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class DeliveryModel {
  final int id;
  final String type;
  final String status;
  final String? estimatedTime;
  final DeliveryWorkerModel? deliveryWorker;
  final DeliveryShopModel? shop;
  final String createdAt;

  DeliveryModel({
    required this.id,
    required this.type,
    required this.status,
    this.estimatedTime,
    this.deliveryWorker,
    this.shop,
    required this.createdAt,
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
      id: json['id'] ?? 0,
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      estimatedTime: json['estimated_time']?.toString(),
      deliveryWorker: workerMap != null
          ? DeliveryWorkerModel.fromJson(workerMap)
          : null,
      shop: shopMap != null ? DeliveryShopModel.fromJson(shopMap) : null,
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
