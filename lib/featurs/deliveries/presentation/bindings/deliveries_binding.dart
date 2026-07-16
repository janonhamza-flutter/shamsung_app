import 'package:get/get.dart';

import '../controllers/deliveries_controller.dart';

class DeliveriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveriesController>(() => DeliveriesController());
  }
}
