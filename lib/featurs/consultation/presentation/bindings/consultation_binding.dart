import 'package:get/get.dart';

import '../controller/consultation_controller.dart';

class ConsultationBinding extends Bindings {
  @override
  void dependencies() {
    // fenix:true — يُعيد بناء الـ controller تلقائياً إذا حُذف من الذاكرة
    // ويمنع إنشاء نسخة مكررة إذا كان موجوداً بالفعل.
    Get.lazyPut<ConsultationController>(
      () => ConsultationController(),
      fenix: true,
    );
  }
}
