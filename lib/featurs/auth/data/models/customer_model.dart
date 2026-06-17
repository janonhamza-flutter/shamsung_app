class CustomerModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthdate;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthdate,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["id"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      birthdate: json["birthdate"] ?? "",
    );
  }
}
