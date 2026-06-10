import 'package:get/get.dart';
import 'package:shamsoung/core/services/storage_service.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  final StorageService storage = StorageService();

  late String customerName;
  @override
  void onInit() {
    customerName = storage.getCustomerName();

    super.onInit();
  }

  void changeBottomNav(int index) {
    currentIndex.value = index;
  }
}
