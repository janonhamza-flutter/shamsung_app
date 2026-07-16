import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/delivery_model.dart';
import '../../data/repositories/deliveries_repository.dart';

class DeliveriesController extends GetxController {
  final DeliveriesRepository _repository = DeliveriesRepository();

  final RxList<DeliveryModel> deliveries = <DeliveryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyDeliveries();
  }

  Future<void> fetchMyDeliveries() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // 1. جلب القائمة لمعرفة الـ IDs
      final result = await _repository.getMyDeliveries();

      // 2. جلب تفاصيل كل delivery بـ /customer/deliveries/{id}
      final detailed = await Future.wait(
        result.deliveries.map((d) => _repository.getDeliveryById(d.id)),
      );

      deliveries.assignAll(detailed);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
