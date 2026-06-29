/// Models for the POST /checkout response.
library;

class CheckoutShopModel {
  final int id;
  final String name;

  CheckoutShopModel({required this.id, required this.name});

  factory CheckoutShopModel.fromJson(Map<String, dynamic> json) {
    return CheckoutShopModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class CheckoutItemAccessoryModel {
  final int id;
  final String name;

  CheckoutItemAccessoryModel({required this.id, required this.name});

  factory CheckoutItemAccessoryModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemAccessoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class CheckoutOrderItemModel {
  final int id;
  final int orderId;
  final int accessoryId;
  final int quantity;
  final double unitPrice;
  final CheckoutItemAccessoryModel? accessory;

  CheckoutOrderItemModel({
    required this.id,
    required this.orderId,
    required this.accessoryId,
    required this.quantity,
    required this.unitPrice,
    this.accessory,
  });

  factory CheckoutOrderItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutOrderItemModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      accessoryId: json['accessory_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,
      accessory: json['accessory'] != null
          ? CheckoutItemAccessoryModel.fromJson(
              json['accessory'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CheckoutOrderModel {
  final int id;
  final String orderNumber;
  final int customerId;
  final int shopId;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String createdAt;
  final CheckoutShopModel? shop;
  final List<CheckoutOrderItemModel> items;

  CheckoutOrderModel({
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

  factory CheckoutOrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .map(
                (e) =>
                    CheckoutOrderItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <CheckoutOrderItemModel>[];

    return CheckoutOrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      customerId: json['customer_id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      shop: json['shop'] != null
          ? CheckoutShopModel.fromJson(json['shop'] as Map<String, dynamic>)
          : null,
      items: items,
    );
  }
}

class CheckoutResponseModel {
  final String message;
  final List<CheckoutOrderModel> orders;

  CheckoutResponseModel({required this.message, required this.orders});

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final orders = raw is List
        ? raw
              .map(
                (e) => CheckoutOrderModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <CheckoutOrderModel>[];

    return CheckoutResponseModel(
      message: json['message'] ?? '',
      orders: orders,
    );
  }
}
