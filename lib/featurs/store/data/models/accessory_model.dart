class ShopModel {
  final int id;
  final String name;
  final String address;

  ShopModel({required this.id, required this.name, required this.address});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class AccessoryModel {
  final int id;
  final int shopId;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final bool isActive;
  final String imageUrl;
  final String createdAt;
  final ShopModel? shop;

  AccessoryModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.isActive,
    required this.imageUrl,
    required this.createdAt,
    this.shop,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    return AccessoryModel(
      id: json['id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stockQuantity: json['stock_quantity'] ?? 0,
      isActive: json['is_active'] ?? false,
      imageUrl: _fixImageUrl(json['image_url'] ?? ''),
      createdAt: json['created_at'] ?? '',
      shop: json['shop'] != null ? ShopModel.fromJson(json['shop']) : null,
    );
  }

  /// يستبدل localhost/127.0.0.1 بالـ base URL الحقيقي للـ server
  static String _fixImageUrl(String url) {
    if (url.isEmpty) return url;
    return url
        .replaceFirst('http://localhost:8000', 'https://shamsung.haderin.sy')
        .replaceFirst('http://127.0.0.1:8000', 'https://shamsung.haderin.sy');
  }
}
