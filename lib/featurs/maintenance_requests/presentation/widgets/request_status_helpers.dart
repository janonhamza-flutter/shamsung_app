import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';

/// Shared status color / label / icon helpers used across
/// MyRequestsPage and RequestDetailsPage.
class RequestStatusHelpers {
  RequestStatusHelpers._();

  static Color color(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
      case 'repairing':
        return Colors.blueAccent;
      case 'under_inspection':
        return const Color(0xFF29B6F6); // light blue
      case 'completed':
      case 'done':
      case 'approved':
        return AppColors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.redAccent;
      case 'waiting_customer_approval':
        return Colors.amber;
      default:
        return Colors.white54;
    }
  }

  static String label(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'status_pending'.tr;
      case 'in_progress':
        return 'status_in_progress'.tr;
      case 'repairing':
        return 'status_repairing'.tr;
      case 'under_inspection':
        return 'status_under_inspection'.tr;
      case 'completed':
        return 'status_completed'.tr;
      case 'done':
        return 'status_done'.tr;
      case 'approved':
        return 'status_approved'.tr;
      case 'rejected':
        return 'status_rejected'.tr;
      case 'cancelled':
        return 'status_cancelled'.tr;
      case 'waiting_customer_approval':
        return 'status_awaiting_approval'.tr;
      default:
        return status.replaceAll('_', ' ');
    }
  }

  static String detailLabel(String status) {
    if (status.toLowerCase() == 'waiting_customer_approval') {
      return 'status_awaiting_your_approval'.tr;
    }
    if (status.toLowerCase() == 'pending') return 'status_pending_review'.tr;
    if (status.toLowerCase() == 'under_inspection') {
      return 'status_under_inspection_detail'.tr;
    }
    return label(status);
  }

  static IconData icon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'in_progress':
      case 'repairing':
        return Icons.build_rounded;
      case 'under_inspection':
        return Icons.search_rounded;
      case 'completed':
      case 'done':
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'waiting_customer_approval':
        return Icons.mark_email_unread_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
