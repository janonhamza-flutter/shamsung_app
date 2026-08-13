import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/route/app_routes.dart';
import 'package:shamsoung/featurs/home/presentation/controller/home_controller.dart';
import 'package:shamsoung/featurs/notifications/presentation/controller/notification_controller.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_palette.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    // Use find with a fallback — controller is permanent so it's always available
    // after NotificationService.initialize() runs in main(), but this guard
    // prevents any edge-case crash if the page loads before the service finishes.
    final NotificationController notificationController =
        Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put<NotificationController>(
            NotificationController(),
            permanent: true,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'hello'.tr}, ${controller.customerName}',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.space5),
            Text(
              'welcome_back'.tr,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 18),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.notifications),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: context.colors.isDark
                  ? null
                  : Border.all(color: context.colors.border),
              boxShadow: context.colors.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: context.colors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_none,
                    color: context.colors.textPrimary,
                    size: 32,
                  ),
                ),
                Obx(
                  () => notificationController.unreadCount.value > 0
                      ? Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: context.colors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
