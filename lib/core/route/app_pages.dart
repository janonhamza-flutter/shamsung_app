import 'package:get/get.dart';
import 'package:shamsoung/featurs/profile/presentation/bindings/profile_binding.dart';
import 'package:shamsoung/featurs/profile/presentation/pages/profile_page.dart';

import '../../featurs/auth/presentation/bindings/auth_binding.dart';
import '../../featurs/auth/presentation/pages/login_page.dart';
import '../../featurs/auth/presentation/pages/signup_page.dart';
import '../../featurs/home/presentation/bindings/home_binding.dart';
import '../../featurs/home/presentation/pages/home_page.dart';
import '../../featurs/splash/bindings/splash_binding.dart';
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
      name: AppRoutes.login,

      page: () => LoginPage(),

      binding: AuthBinding(),
    ),
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
  ];
}
