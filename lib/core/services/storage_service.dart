import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  // =========================
  // TOKEN
  // =========================

  void saveToken(String token) {
    _box.write("token", token);
  }

  String getToken() {
    return _box.read("token") ?? "";
  }

  // =========================
  // CUSTOMER ID
  // =========================

  void saveCustomerId(int id) {
    _box.write("customerId", id);
  }

  int getCustomerId() {
    return _box.read("customerId") ?? 0;
  }

  // =========================
  // CUSTOMER NAME
  // =========================

  void saveCustomerName(String name) {
    _box.write("customerName", name);
  }

  String getCustomerName() {
    return _box.read("customerName") ?? "";
  }

  // =========================
  // CUSTOMER EMAIL
  // =========================

  void saveCustomerEmail(String email) {
    _box.write("customerEmail", email);
  }

  String getCustomerEmail() {
    return _box.read("customerEmail") ?? "";
  }

  // =========================
  // LOGIN CHECK
  // =========================

  bool isLoggedIn() {
    return getToken().isNotEmpty;
  }

  // =========================
  // LOGOUT
  // =========================

  void clearData() {
    _box.erase();
  }
}
