import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_snackbar.dart';

/// Centralized DioException → user message resolver for maintenance request
/// actions. Keeps individual controller methods short and consistent.
class RequestActionHandler {
  RequestActionHandler._();

  /// Resolves a [DioException] to an error snackbar message.
  /// [action] is a short label used in debug logs (e.g. "APPROVE").
  static void handleDioError(
    DioException e, {
    required String action,
    Map<int, String> statusMessages = const {},
  }) {
    final status = e.response?.statusCode;
    final serverMsg = e.response?.data?["message"]?.toString();

    debugPrint("▶ $action DIO ERROR status = $status");
    debugPrint("▶ $action DIO ERROR body   = ${e.response?.data}");

    final message =
        statusMessages[status] ?? serverMsg ?? _defaultMessage(status, action);

    AppSnackbar.error(message);
  }

  /// Handles unexpected (non-Dio) errors.
  static void handleUnexpectedError(Object e, {required String action}) {
    debugPrint("▶ $action ERROR = $e");
    AppSnackbar.error("An unexpected error occurred.");
  }

  static String _defaultMessage(int? status, String action) {
    if (status == 401) return "Session expired. Please log in again.";
    if (status == 404) return "Request not found.";
    if (status == 400)
      return "Cannot perform this action at the current stage.";
    if (status != null) return "Server error ($status).";
    return "Network error. Check your connection.";
  }
}
