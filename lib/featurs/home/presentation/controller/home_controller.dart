import 'package:get/get.dart';
import 'package:shamsoung/core/services/notification_service.dart';
import 'package:shamsoung/core/services/storage_service.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  final StorageService storage = StorageService();

  late String customerName;

  @override
  void onInit() {
    customerName = storage.getCustomerName();
    // Re-sync token in case it changed while the app was closed
    NotificationService.syncTokenAfterLogin();
    super.onInit();
  }

  void changeBottomNav(int index) {
    currentIndex.value = index;
  }
}
