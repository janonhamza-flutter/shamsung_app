import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersController extends GetxController {
  final OrdersRepository _repository = OrdersRepository();

  // ── State ──────────────────────────────────────────────────────────────
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchMyOrders();
  }

  // ── Fetch Orders — GET /orders ────────────────────────────────────────────
  Future<void> fetchMyOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _repository.getMyOrders();
      orders.assignAll(result.orders);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
