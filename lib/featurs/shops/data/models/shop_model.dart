class ShopModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final double rating;
  final bool isActive;
  final String? imageUrl;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.isActive,
    this.imageUrl,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? false,
      imageUrl: _resolveImageUrl(json['image_url'] ?? json['image_path']),
    );
  }

  /// يدعم image_url (كامل) و image_path (نسبي) معاً
  static String? _resolveImageUrl(dynamic raw) {
    if (raw == null) return null;
    final str = raw.toString().trim();
    if (str.isEmpty) return null;

    // إذا كان URL كاملاً ابدأ بـ http
    if (str.startsWith('http')) {
      return str
          .replaceFirst('http://localhost:8000', 'https://shamsung.haderin.sy')
          .replaceFirst('http://127.0.0.1:8000', 'https://shamsung.haderin.sy');
    }

    // مسار نسبي مثل "shops/image.jpg" — أضف الـ storage base URL
    return 'https://shamsung.haderin.sy/storage/$str';
  }
}
