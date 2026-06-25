import 'accessory_model.dart';

class CartItemModel {
  int cartItemId; // server-side cart row ID — updated after each POST /cart
  final AccessoryModel accessory;
  int quantity;

  CartItemModel({
    this.cartItemId = 0,
    required this.accessory,
    this.quantity = 1,
  });

  double get totalPrice => accessory.price * quantity;
}

class CartResponseModel {
  final int id;
  final int customerId;
  final int accessoryId;
  final int quantity;
  final String accessoryName;
  final double accessoryPrice;

  CartResponseModel({
    required this.id,
    required this.customerId,
    required this.accessoryId,
    required this.quantity,
    required this.accessoryName,
    required this.accessoryPrice,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final accessory = data['accessory'] as Map<String, dynamic>? ?? {};
    return CartResponseModel(
      id: data['id'] ?? 0,
      customerId: data['customer_id'] ?? 0,
      accessoryId: data['accessory_id'] ?? 0,
      quantity: data['quantity'] ?? 1,
      accessoryName: accessory['name'] ?? '',
      accessoryPrice: double.tryParse(accessory['price'].toString()) ?? 0.0,
    );
  }
}
