import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../controller/otp_controller.dart';
import '../controller/send_otp_controller.dart';
import '../controller/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());

    Get.lazyPut<SendOtpController>(() => SendOtpController());

    Get.lazyPut<OtpController>(() => OtpController());

    Get.lazyPut<SignupController>(() => SignupController());
  }
}
