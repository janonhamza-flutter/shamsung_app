import '../../../../core/services/dio_service.dart';
import '../models/otp_response_model.dart';

class AuthRepository {
  final DioService dioService = DioService();

  /// LOGIN

  // Future login({required String login, required String password}) async {
  //   return await dioService.postData(
  //     endpoint: "/customer/login",
  //     data: {"login": login, "password": password},
  //   );
  // }

  ///  send otp

  Future sendOtp({required String phone}) async {
    return await dioService.postData(
      endpoint: "/customer/send-otp",
      data: {"phone": phone},
    );
  }

  /// verify otp

  Future<OtpResponseModel> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await dioService.postData(
      endpoint: "/customer/verify-otp",
      data: {"phone": phone, "code": code},
    );

    return OtpResponseModel.fromJson(response.data);
  }

  /// SIGN UP

  Future signUp({
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
