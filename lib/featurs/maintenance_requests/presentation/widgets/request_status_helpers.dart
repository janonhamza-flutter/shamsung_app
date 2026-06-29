import 'package:flutter/material.dart';
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
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'repairing':
        return 'Repairing';
      case 'completed':
        return 'Completed';
      case 'done':
        return 'Done';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      case 'waiting_customer_approval':
        return 'Awaiting Approval';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  static String detailLabel(String status) {
    if (status.toLowerCase() == 'waiting_customer_approval') {
      return 'Awaiting Your Approval';
    }
    if (status.toLowerCase() == 'pending') return 'Pending Review';
    return label(status);
  }

  static IconData icon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'in_progress':
      case 'repairing':
        return Icons.build_rounded;
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
