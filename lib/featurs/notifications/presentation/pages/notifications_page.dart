import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lottie_loading.dart';
import '../controller/notification_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    debugPrint('🏷 NotificationsPage.initState called');
    // جلب الإشعارات عند كل فتح للصفحة لضمان عرض اللغة الصحيحة
    controller.fetchNotifications();
  }

  @override
  void dispose() {
    debugPrint('🏷 NotificationsPage.dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        title: Text(
          'notifications'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: Text(
              'mark_all_read'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return LottieLoading(label: 'loading_notifications'.tr);
        }

        // Empty
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/Bell Snooze.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  repeat: true,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(const ['**'], value: AppColors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'no_notifications'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'all_caught_up'.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // List
        return RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.blue,
          onRefresh: controller.fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              debugPrint(
                '📝 Notification widget [$index] id=${item.id} title="${item.title}" body="${item.body}"',
              );
              return InkWell(
                onTap: () => controller.markAsRead(item.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: item.isRead ? Colors.white10 : AppColors.blue,
                    borderRadius: BorderRadius.circular(16),
                    border: item.isRead
                        ? null
                        : Border.all(
                            color: AppColors.green.withValues(alpha: 0.3),
                          ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.isRead
                              ? Colors.white10
                              : AppColors.green.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForType(item.type),
                          color: item.isRead ? Colors.white38 : AppColors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: item.isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (!item.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.body,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(item.createdAt),
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'maintenance_request':
        return Icons.build_rounded;
      case 'consultation':
        return Icons.chat_bubble_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) {
      return '${'time_days_ago'.tr} ${diff.inDays} ${'time_days'.tr}';
    }
    if (diff.inHours > 0) {
      return '${'time_hours_ago'.tr} ${diff.inHours} ${'time_hours'.tr}';
    }
    if (diff.inMinutes > 0) {
      return '${'time_minutes_ago'.tr} ${diff.inMinutes} ${'time_minutes'.tr}';
    }
    return 'just_now'.tr;
  }
}
