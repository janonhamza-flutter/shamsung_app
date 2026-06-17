import 'package:get/get.dart';

import '../../data/models/maintenance_request_model.dart';
import '../../data/repositories/maintenance_requests_repository.dart';

class MyRequestsController extends GetxController {
  final MaintenanceRequestsRepository repository =
      MaintenanceRequestsRepository();

  RxBool isLoading = false.obs;

  RxList<MaintenanceRequestModel> requests = <MaintenanceRequestModel>[].obs;

  @override
  void onInit() {
    getRequests();
    super.onInit();
  }

  Future<void> getRequests() async {
    try {
      isLoading.value = true;

      final response = await repository.getAllRequests();
      print("STATUS = ${response.statusCode}");
      print("BODY = ${response.data}");
      final List requestsList = response.data["data"]["data"];

      requests.value = requestsList
          .map((e) => MaintenanceRequestModel.fromJson(e))
          .toList();
      print("REQUESTS COUNT = ${requests.length}");
    } catch (e) {
      print("ERROR = $e");
    } finally {
      isLoading.value = false;
    }
  }
}
