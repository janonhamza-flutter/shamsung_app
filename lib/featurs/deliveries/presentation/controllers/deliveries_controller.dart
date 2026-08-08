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
      // طلب واحد فقط — القائمة تحتوي على كل البيانات الكاملة
      final result = await _repository.getMyDeliveries();
      deliveries.assignAll(result.deliveries);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
