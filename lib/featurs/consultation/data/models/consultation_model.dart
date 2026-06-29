class ConsultationModel {
  final int id;
  final int customerId;
  final int? technicianId;
  final String consultationType; // "ai" | "technician"
  final String message;
  final String? imagePath;
  final String status; // "ai_answered" | "pending" | "answered"
  final String? reply;
  final String createdAt;
  final String updatedAt;

  const ConsultationModel({
    required this.id,
    required this.customerId,
    this.technicianId,
    required this.consultationType,
    required this.message,
    this.imagePath,
    required this.status,
    this.reply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      technicianId: json['technician_id'],
      consultationType: json['consultation_type'] ?? '',
      message: json['message'] ?? '',
      imagePath: json['image_path'],
      status: json['status'] ?? '',
      reply: json['reply'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  ConsultationModel copyWith({
    String? status,
    String? reply,
    int? technicianId,
  }) {
    return ConsultationModel(
      id: id,
      customerId: customerId,
      technicianId: technicianId ?? this.technicianId,
      consultationType: consultationType,
      message: message,
      imagePath: imagePath,
      status: status ?? this.status,
      reply: reply ?? this.reply,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get isAi => consultationType == 'ai';
  bool get isPending => status == 'pending';
  bool get isAnswered => reply != null && reply!.isNotEmpty;
}
