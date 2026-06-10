import '../../../../core/services/dio_service.dart';

class AuthRepository {
  final DioService dioService = DioService();

  /// LOGIN

  Future login({required String login, required String password}) async {
    return await dioService.postData(
      endpoint: "/customer/login",
      data: {"login": login, "password": password},
    );
  }

  /// SIGN UP

  Future signUp( {
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String birthdate, 
  }) async {
    return await dioService.postData(
      endpoint: "/customer/register",
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "birthdate": birthdate,
      },
    );
  }
}
