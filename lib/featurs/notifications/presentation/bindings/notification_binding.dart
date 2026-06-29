import 'package:get/get.dart';

import '../controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // FIX #1: If NotificationService already created a permanent instance
    // (before the user navigated here), reuse it — never create a second one.
    if (!Get.isRegistered<NotificationController>()) {
      Get.put<NotificationController>(
        NotificationController(),
        permanent: true,
      );
    }
  }
}
