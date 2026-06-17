import 'package:get/get.dart';
import 'package:shamsoung/featurs/profile/presentation/bindings/profile_binding.dart';
import 'package:shamsoung/featurs/profile/presentation/pages/profile_page.dart';

import '../../featurs/auth/presentation/bindings/auth_binding.dart';
import '../../featurs/auth/presentation/pages/login_page.dart';
import '../../featurs/auth/presentation/pages/otp_page.dart';
import '../../featurs/auth/presentation/pages/send_otp_page.dart';
import '../../featurs/auth/presentation/pages/signup_page.dart';
import '../../featurs/home/presentation/bindings/home_binding.dart';
import '../../featurs/home/presentation/pages/home_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/create_request_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/my_request_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/request_details_page.dart';
import '../../featurs/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../featurs/onboarding/presentation/pages/onboarding_page.dart';
import '../../featurs/profile/presentation/pages/about_page.dart';
import '../../featurs/splash/presentation/bindings/splash_binding.dart';
import '../../featurs/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,

      page: () => SplashPage(),

      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingPage(),
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: AppRoutes.login,

      page: () => LoginPage(),

      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.sendOtp,
      page: () => SendOtpPage(),
      binding: AuthBinding(),
    ),

    GetPage(name: AppRoutes.otp, page: () => OtpPage(), binding: AuthBinding()),

    GetPage(
      name: AppRoutes.signup,

      page: () => SignupPage(),

      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.home,

      page: () => HomePage(),

      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),

    GetPage(name: AppRoutes.about, page: () => const AboutPage()),

    GetPage(name: AppRoutes.createRequest, page: () => CreateRequestPage()),
    GetPage(name: AppRoutes.myRequests, page: () => MyRequestsPage()),

    GetPage(name: AppRoutes.requestDetails, page: () => RequestDetailsPage()),
  ];
}
