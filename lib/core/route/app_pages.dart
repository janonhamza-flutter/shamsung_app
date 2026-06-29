import 'package:get/get.dart';
import 'package:shamsoung/featurs/consultation/data/models/consultation_model.dart';
import 'package:shamsoung/featurs/consultation/presentation/bindings/consultation_binding.dart';
import 'package:shamsoung/featurs/consultation/presentation/pages/consultation_chat_page.dart';
import 'package:shamsoung/featurs/consultation/presentation/pages/consultation_list_page.dart';
import 'package:shamsoung/featurs/consultation/presentation/pages/create_consultation_page.dart';
import 'package:shamsoung/featurs/profile/presentation/bindings/profile_binding.dart';
import 'package:shamsoung/featurs/profile/presentation/pages/profile_page.dart';

import '../../featurs/auth/presentation/bindings/auth_binding.dart';
import '../../featurs/auth/presentation/pages/otp_page.dart';
import '../../featurs/auth/presentation/pages/send_otp_page.dart';
import '../../featurs/auth/presentation/pages/signup_page.dart';
import '../../featurs/home/presentation/bindings/home_binding.dart';
import '../../featurs/home/presentation/pages/home_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/create_request_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/my_request_page.dart';
import '../../featurs/maintenance_requests/presentation/pages/request_details_page.dart';
import '../../featurs/notifications/presentation/bindings/notification_binding.dart';
import '../../featurs/notifications/presentation/pages/notifications_page.dart';
import '../../featurs/onboarding/presentation/bindings/onboarding_binding.dart';
import '../../featurs/onboarding/presentation/pages/onboarding_page.dart';
import '../../featurs/profile/presentation/pages/about_page.dart';
import '../../featurs/splash/presentation/bindings/splash_binding.dart';
import '../../featurs/splash/presentation/pages/splash_page.dart';
import '../../featurs/orders/presentation/bindings/orders_binding.dart';
import '../../featurs/orders/presentation/pages/my_orders_page.dart';
import '../../featurs/store/presentation/bindings/store_binding.dart';
import '../../featurs/store/presentation/pages/accessory_details_page.dart';
import '../../featurs/store/presentation/pages/cart_page.dart';
import '../../featurs/store/presentation/pages/checkout_page.dart';
import '../../featurs/store/presentation/pages/store_page.dart';
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
      name: AppRoutes.notifications,
      page: () => NotificationsPage(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(name: AppRoutes.about, page: () => AboutPage()),
    GetPage(name: AppRoutes.createRequest, page: () => CreateRequestPage()),
    GetPage(name: AppRoutes.myRequests, page: () => MyRequestsPage()),
    GetPage(name: AppRoutes.requestDetails, page: () => RequestDetailsPage()),
    // Store
    GetPage(
      name: AppRoutes.store,
      page: () => StorePage(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.accessoryDetails,
      page: () => AccessoryDetailsPage(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => CartPage(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => CheckoutPage(),
      binding: StoreBinding(),
    ),
    // Orders
    GetPage(
      name: AppRoutes.myOrders,
      page: () => MyOrdersPage(),
      binding: OrdersBinding(),
    ),
    // Consultation
    GetPage(
      name: AppRoutes.consultations,
      page: () => const ConsultationListPage(),
      binding: ConsultationBinding(),
    ),
    GetPage(
      name: AppRoutes.createConsultation,
      page: () => const CreateConsultationPage(),
      binding: ConsultationBinding(),
    ),
    GetPage(
      name: AppRoutes.consultationChat,
      page: () => ConsultationChatPage(
        initialConsultation: Get.arguments as ConsultationModel?,
      ),
      binding: ConsultationBinding(),
    ),
  ];
}
