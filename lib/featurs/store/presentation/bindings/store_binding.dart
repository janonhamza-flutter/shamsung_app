import 'package:get/get.dart';
import '../controllers/store_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    // fenix:true keeps the instance alive while navigating between
    // store sub-pages; it re-creates only if fully disposed.
    Get.lazyPut<StoreController>(() => StoreController(), fenix: true);
  }
}
