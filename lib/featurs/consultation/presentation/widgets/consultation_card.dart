import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../data/models/consultation_model.dart';
import '../controller/consultation_controller.dart';

/// Returns [darkColor] unchanged in Dark Mode; in Light Mode returns
/// [lightColor], a deepened variant tuned for legibility on light surfaces.
/// Used to distinguish "AI" vs "technician" consultations — a decorative
/// pairing that doesn't map onto the semantic palette fields.
Color _typeAccent(BuildContext context, bool isAi) {
  if (isAi) {
    return context.colors.isDark
        ? Colors.purpleAccent
        : const Color(0xFF7B1FA2);
  }
  return context.colors.isDark ? Colors.blueAccent : const Color(0xFF1565C0);
}

class ConsultationCard extends StatelessWidget {
  final ConsultationModel consultation;

  const ConsultationCard({super.key, required this.consultation});

  @override
  Widget build(BuildContext context) {
    final isAi = consultation.isAi;
    final hasReply = consultation.isAnswered;
    final ctrl = Get.find<ConsultationController>();

    return Dismissible(
      key: ValueKey(consultation.id),
      direction: DismissDirection.endToStart,
      // ── خلفية السحب (أحمر + أيقونة حذف) ──
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: context.colors.textOnPrimary,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              'delete'.tr,
              style: TextStyle(
                color: context.colors.textOnPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await _confirmDelete(context);
      },
      onDismissed: (_) {
        ctrl.deleteConsultation(consultation.id);
      },
      child: GestureDetector(
        onTap: () =>
            Get.toNamed(AppRoutes.consultationChat, arguments: consultation),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _statusColor(
                context,
                consultation.status,
              ).withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────
                Row(
                  children: [
                    _TypeChip(isAi: isAi),
                    const SizedBox(width: 8),
                    _StatusChip(status: consultation.status),
                    const Spacer(),
                    Text(
                      _formatDate(consultation.createdAt),
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // زر حذف صريح
                    GestureDetector(
                      onTap: () async {
                        final confirmed = await _confirmDelete(context);
                        if (confirmed == true) {
                          ctrl.deleteConsultation(consultation.id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline,
                          color: context.colors.error,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      color: context.colors.textDisabled,
                      size: 18,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── السؤال ────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: context.colors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        consultation.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── الرد ──────────────────────────────────
                if (hasReply) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.colors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: context.colors.success.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isAi
                              ? Icons.smart_toy_outlined
                              : Icons.build_circle_outlined,
                          color: context.colors.success,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            consultation.reply!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAi
                            ? 'awaiting_ai_response'.tr
                            : 'awaiting_technician_response'.tr,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// dialog تأكيد الحذف
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'delete_consultation'.tr,
          style: TextStyle(
            color: dialogContext.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'delete_consultation_confirm'.tr,
          style: TextStyle(color: dialogContext.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: dialogContext.colors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: dialogContext.colors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'delete'.tr,
              style: TextStyle(color: dialogContext.colors.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'ai_answered':
      case 'answered':
        return context.colors.success;
      case 'pending':
        return context.colors.warning;
      default:
        return context.colors.textSecondary;
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}

// ── Chips ────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  final bool isAi;
  const _TypeChip({required this.isAi});

  @override
  Widget build(BuildContext context) {
    final color = _typeAccent(context, isAi);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAi ? Icons.smart_toy_outlined : Icons.engineering_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isAi
                ? 'consultation_type_ai'.tr
                : 'consultation_type_technician'.tr,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String labelKey;
    switch (status) {
      case 'ai_answered':
      case 'answered':
        color = context.colors.success;
        labelKey = 'consultation_status_answered';
        break;
      case 'pending':
        color = context.colors.warning;
        labelKey = 'consultation_status_pending';
        break;
      default:
        color = context.colors.textSecondary;
        labelKey = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        labelKey.tr,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
