import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../data/models/maintenance_request_details_model.dart';
import '../../data/repositories/maintenance_requests_repository.dart';
import 'request_action_handler.dart';

class RequestDetailsController extends GetxController {
  final MaintenanceRequestsRepository _repo = MaintenanceRequestsRepository();

  // ── State: details ────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final request = Rxn<MaintenanceRequestDetailsModel>();

  // ── State: parts ──────────────────────────────────────────────────────────
  final isPartsLoading = false.obs;
  final partsErrorMessage = ''.obs;
  final requestParts = Rxn<RequestPartsModel>();

  // ── State: approve ────────────────────────────────────────────────────────
  final isApproving = false.obs;
  final selectedPartIds = <int>{}.obs;
  final selectedPaymentMethod = "cash_on_delivery".obs;
  double? approveLatitude;
  double? approveLongitude;

  List<Map<String, String>> get paymentMethods => [
    {"value": "cash_on_delivery", "label": 'payment_cash_on_delivery'.tr},
    {"value": "pay_after_service", "label": 'payment_pay_after_service'.tr},
  ];

  // ── State: reject ─────────────────────────────────────────────────────────
  final isRejecting = false.obs;
  final rejectionReasonController = TextEditingController();

  // ── State: cancel ─────────────────────────────────────────────────────────
  final isCancelling = false.obs;

  late final int requestId;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    requestId = Get.arguments as int;
    getDetails();
    super.onInit();
  }

  @override
  void onClose() {
    rejectionReasonController.dispose();
    super.onClose();
  }

  // ── Fetch details ─────────────────────────────────────────────────────────

  Future<void> getDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repo.getRequestDetails(requestId);
      debugPrint("▶ DETAILS STATUS = ${response.statusCode}");

      request.value = MaintenanceRequestDetailsModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );

      await getRequestParts();
    } on DioException catch (e) {
      errorMessage.value = _detailsError(e);
    } catch (e) {
      debugPrint("▶ DETAILS ERROR = $e");
      errorMessage.value = "Failed to load request details.";
    } finally {
      isLoading.value = false;
    }
  }

  String _detailsError(DioException e) {
    final status = e.response?.statusCode;
    debugPrint("▶ DIO ERROR status = $status");
    if (status == 401) return "Session expired. Please log in again.";
    if (status == 404) return "Request not found.";
    if (status != null) return "Server error ($status).";
    return "Network error. Check your connection.";
  }

  // ── Fetch parts ───────────────────────────────────────────────────────────

  Future<void> getRequestParts() async {
    try {
      isPartsLoading.value = true;
      partsErrorMessage.value = '';

      final response = await _repo.getRequestParts(requestId);
      debugPrint("▶ PARTS STATUS = ${response.statusCode}");

      requestParts.value = RequestPartsModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );

      _initSelectedParts();
    } on DioException catch (e) {
      debugPrint("▶ PARTS DIO ERROR = ${e.response?.statusCode}");
      partsErrorMessage.value = "Could not load parts details.";
    } catch (e) {
      debugPrint("▶ PARTS ERROR = $e");
      partsErrorMessage.value = "Could not load parts details.";
    } finally {
      isPartsLoading.value = false;
    }
  }

  void _initSelectedParts() {
    final parts = requestParts.value?.parts ?? request.value?.parts ?? [];
    selectedPartIds.assignAll(
      parts.where((p) => p.isRequired || p.isSelected).map((p) => p.id),
    );
  }

  // ── Parts selection helpers ───────────────────────────────────────────────

  void togglePart(PartModel part) {
    if (part.isRequired) return; // required parts cannot be deselected
    if (selectedPartIds.contains(part.id)) {
      selectedPartIds.remove(part.id);
    } else {
      selectedPartIds.add(part.id);
    }
  }

  double get selectedTotal {
    final parts = requestParts.value?.parts ?? request.value?.parts ?? [];
    return parts
        .where((p) => selectedPartIds.contains(p.id))
        .fold(0.0, (sum, p) => sum + p.total);
  }

  // ── Approve ───────────────────────────────────────────────────────────────

  Future<void> approveRequest() async {
    if (selectedPartIds.isEmpty) {
      AppSnackbar.error("Please select at least one part.");
      return;
    }

    if (approveLatitude == null || approveLongitude == null) {
      AppSnackbar.error("Please select a pickup location from the map.");
      return;
    }

    try {
      isApproving.value = true;

      final response = await _repo.approveRequest(
        id: requestId,
        selectedParts: selectedPartIds.toList(),
        paymentMethod: selectedPaymentMethod.value,
        latitude: approveLatitude!,
        longitude: approveLongitude!,
      );

      debugPrint("▶ APPROVE STATUS = ${response.statusCode}");
      request.value = MaintenanceRequestDetailsModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );

      Get.back();
      AppSnackbar.success("Request approved successfully!");
    } on DioException catch (e) {
      RequestActionHandler.handleDioError(
        e,
        action: "APPROVE",
        statusMessages: {
          422: e.response?.data?["message"]?.toString() ?? "Validation error.",
          403: "This request cannot be approved at this stage.",
        },
      );
    } catch (e) {
      RequestActionHandler.handleUnexpectedError(e, action: "APPROVE");
    } finally {
      isApproving.value = false;
    }
  }

  // ── Reject ────────────────────────────────────────────────────────────────

  Future<void> rejectRequest() async {
    final reason = rejectionReasonController.text.trim();
    if (reason.isEmpty) {
      AppSnackbar.error("Please enter a rejection reason.");
      return;
    }

    try {
      isRejecting.value = true;

      final response = await _repo.rejectRequest(
        id: requestId,
        rejectionReason: reason,
      );

      debugPrint("▶ REJECT STATUS = ${response.statusCode}");
      request.value = MaintenanceRequestDetailsModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );

      Get.back();
      AppSnackbar.success("Request rejected.");
    } on DioException catch (e) {
      RequestActionHandler.handleDioError(
        e,
        action: "REJECT",
        statusMessages: {404: "This request cannot be rejected at this stage."},
      );
    } catch (e) {
      RequestActionHandler.handleUnexpectedError(e, action: "REJECT");
    } finally {
      isRejecting.value = false;
    }
  }

  // ── Cancel ────────────────────────────────────────────────────────────────

  Future<void> cancelRequest() async {
    try {
      isCancelling.value = true;

      final response = await _repo.cancelRequest(id: requestId);
      debugPrint("▶ CANCEL STATUS = ${response.statusCode}");

      request.value = MaintenanceRequestDetailsModel.fromJson(
        response.data["data"] as Map<String, dynamic>,
      );

      AppSnackbar.success("Request cancelled successfully.");
    } on DioException catch (e) {
      RequestActionHandler.handleDioError(
        e,
        action: "CANCEL",
        statusMessages: {
          400:
              e.response?.data?["message"]?.toString() ??
              "Cannot cancel: request is no longer pending.",
        },
      );
    } catch (e) {
      RequestActionHandler.handleUnexpectedError(e, action: "CANCEL");
    } finally {
      isCancelling.value = false;
    }
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  @override
  Future<void> refresh() async => getDetails();
}
