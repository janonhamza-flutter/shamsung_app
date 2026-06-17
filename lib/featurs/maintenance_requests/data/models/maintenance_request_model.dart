class MaintenanceRequestModel {
  final int id;
  final String trackingNumber;
  final String deviceModel;
  final String problemDescription;
  final String status;
  final String customerStatus;
  final String? estimatedCost;
  final int? estimatedDays;

  MaintenanceRequestModel({
    required this.id,
    required this.trackingNumber,
    required this.deviceModel,
    required this.problemDescription,
    required this.status,
    required this.customerStatus,
    this.estimatedCost,
    this.estimatedDays,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestModel(
      id: json["id"],
      trackingNumber: json["tracking_number"] ?? "",
      deviceModel: json["device_model"] ?? "",
      problemDescription: json["problem_description"] ?? "",
      status: json["status"] ?? "",
      customerStatus: json["customer_status"] ?? "",
      estimatedCost: json["estimated_cost"]?.toString(),
      estimatedDays: json["estimated_days"],
    );
  }
}
