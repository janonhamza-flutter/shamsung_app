import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  void saveOnboardingSeen() {
    _box.write("onboardingSeen", true);
  }

  bool isOnboardingSeen() {
    return _box.read("onboardingSeen") ?? false;
  }

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
  // FCM TOKEN
  // =========================

  void saveFcmToken(String token) {
    _box.write("fcmToken", token);
  }

  String getFcmToken() {
    return _box.read("fcmToken") ?? "";
  }

  // =========================
  // NOTIFICATIONS
  // =========================

  void saveNotifications(List<Map<String, dynamic>> notifications) {
    _box.write("notifications", notifications);
  }

  List<Map<String, dynamic>> getNotifications() {
    final data = _box.read("notifications");
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  // =========================
  // CONSULTATION THREADS
  // =========================

  /// يحفظ رسائل محادثة معينة بـ consultationId
  void saveThread(int consultationId, List<Map<String, dynamic>> messages) {
    _box.write('thread_$consultationId', messages);
  }

  /// يقرأ رسائل محادثة معينة
  List<Map<String, dynamic>> loadThread(int consultationId) {
    final data = _box.read('thread_$consultationId');
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  /// يمسح thread محادثة معينة
  void clearThread(int consultationId) {
    _box.remove('thread_$consultationId');
  }

  // =========================
  // HIDDEN CONSULTATION IDs
  // (استشارات أُنشئت كرسائل إضافية — لا تظهر كـ cards منفصلة)
  // =========================

  void saveHiddenConsultationIds(Set<int> ids) {
    _box.write('hiddenConsultationIds', ids.toList());
  }

  Set<int> loadHiddenConsultationIds() {
    final data = _box.read('hiddenConsultationIds');
    if (data is List) {
      return data.map((e) => e as int).toSet();
    }
    return {};
  }

  // =========================
  // LANGUAGE
  // =========================

  void saveLanguage(String languageCode) {
    _box.write('languageCode', languageCode);
  }

  /// Returns saved language code, defaults to 'en'
  String getLanguage() {
    return _box.read('languageCode') ?? 'en';
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
