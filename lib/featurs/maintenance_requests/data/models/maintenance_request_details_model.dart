class ShopModel {
  final int id;
  final String name;
  final String address;
  final String phone;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}

class PartModel {
  final int id;
  final String name;
  final String price;
  final int quantity;
  final bool isRequired;
  final bool isSelected;

  PartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isRequired,
    required this.isSelected,
  });

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return PartModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"]?.toString() ?? "0",
      quantity: json["quantity"] ?? 1,
      isRequired: json["is_required"] ?? false,
      isSelected: json["is_selected"] ?? false,
    );
  }

  /// Total cost for this line (price × quantity)
  double get total {
    return (double.tryParse(price) ?? 0) * quantity;
  }
}

class MaintenanceRequestDetailsModel {
  final int id;
  final String trackingNumber;
  final String deviceModel;
  final String problemDescription;
  final String status;
  final String customerStatus;
  final String? estimatedCost;
  final int? estimatedDays;
  final String? paymentMethod;
  final String? rejectionReason;
  final String? createdAt;
  final ShopModel? shop;
  final List<PartModel> parts;

  MaintenanceRequestDetailsModel({
    required this.id,
    required this.trackingNumber,
    required this.deviceModel,
    required this.problemDescription,
    required this.status,
    required this.customerStatus,
    this.estimatedCost,
    this.estimatedDays,
    this.paymentMethod,
    this.rejectionReason,
    this.createdAt,
    this.shop,
    required this.parts,
  });

  factory MaintenanceRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestDetailsModel(
      id: json["id"] ?? 0,
      trackingNumber: json["tracking_number"] ?? "",
      deviceModel: json["device_model"] ?? "",
      problemDescription: json["problem_description"] ?? "",
      status: json["status"] ?? "",
      customerStatus: json["customer_status"] ?? "",
      estimatedCost: json["estimated_cost"]?.toString(),
      estimatedDays: json["estimated_days"],
      paymentMethod: json["payment_method"]?.toString(),
      rejectionReason: json["rejection_reason"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      shop: json["shop"] != null ? ShopModel.fromJson(json["shop"]) : null,
      // API key is "parts" (not "required_parts")
      parts: (json["parts"] as List? ?? [])
          .map((e) => PartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Sum of all parts prices × quantities
  double get totalPartsPrice {
    return parts.fold(0, (sum, p) => sum + p.total);
  }
}

/// Response model for GET /maintenance-requests/{id}/parts
/// { "data": { "estimated_days": N, "parts": [...] } }
class RequestPartsModel {
  final int? estimatedDays;
  final List<PartModel> parts;

  RequestPartsModel({required this.estimatedDays, required this.parts});

  factory RequestPartsModel.fromJson(Map<String, dynamic> json) {
    return RequestPartsModel(
      estimatedDays: json["estimated_days"],
      parts: (json["parts"] as List? ?? [])
          .map((e) => PartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  double get totalPrice {
    return parts.fold(0, (sum, p) => sum + p.total);
  }

  List<PartModel> get requiredParts =>
      parts.where((p) => p.isRequired).toList();

  List<PartModel> get optionalParts =>
      parts.where((p) => !p.isRequired).toList();
}
