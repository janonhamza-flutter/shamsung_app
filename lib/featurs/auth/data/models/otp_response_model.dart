import 'customer_model.dart';

class OtpResponseModel {
  final bool isNewUser;

  final String token;

  final CustomerModel? customer;

  OtpResponseModel({
    required this.isNewUser,
    required this.token,
    this.customer,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return OtpResponseModel(
      isNewUser: data["is_new_user"] ?? false,

      token: data["token"] ?? "",

      customer: data["customer"] != null
          ? CustomerModel.fromJson(data["customer"])
          : null,
    );
  }
}
