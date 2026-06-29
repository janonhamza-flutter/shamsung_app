/// Models for GET /orders response.
library;

class OrderShopModel {
  final int id;
  final String name;

  OrderShopModel({required this.id, required this.name});

  factory OrderShopModel.fromJson(Map<String, dynamic> json) {
    return OrderShopModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class OrderItemAccessoryModel {
  final int id;
  final String name;

  OrderItemAccessoryModel({required this.id, required this.name});

  factory OrderItemAccessoryModel.fromJson(Map<String, dynamic> json) {
    return OrderItemAccessoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int accessoryId;
  final int quantity;
  final double unitPrice;
  final OrderItemAccessoryModel? accessory;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.accessoryId,
    required this.quantity,
    required this.unitPrice,
    this.accessory,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      accessoryId: json['accessory_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,
      accessory: json['accessory'] != null
          ? OrderItemAccessoryModel.fromJson(
              json['accessory'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final int customerId;
  final int shopId;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String createdAt;
  final OrderShopModel? shop;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.shopId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.shop,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <OrderItemModel>[];

    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      customerId: json['customer_id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      shop: json['shop'] != null
          ? OrderShopModel.fromJson(json['shop'] as Map<String, dynamic>)
          : null,
      items: items,
    );
  }
}

class OrdersResponseModel {
  final String message;
  final List<OrderModel> orders;

  OrdersResponseModel({required this.message, required this.orders});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    // The API returns a paginated response:
    // { "message": "...", "data": { "current_page": 1, "data": [ {...} ] } }
    List<OrderModel> extractOrders(dynamic field) {
      if (field == null) return [];

      // Case 1: field is directly a List → { "data": [ {...} ] }
      if (field is List) {
        return field
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Case 2: field is a paginated Map → { "data": { "current_page":1, "data": [...] } }
      if (field is Map) {
        final inner = field['data'];
        if (inner is List) {
          return inner
              .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    }

    final orders = extractOrders(json['data'] ?? json['orders']);

    return OrdersResponseModel(
      message: json['message']?.toString() ?? '',
      orders: orders,
    );
  }
}
