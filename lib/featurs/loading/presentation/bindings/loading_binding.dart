import 'package:get/get.dart';
import '../controller/loading_controller.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingController>(() => LoadingController());
  }
}
