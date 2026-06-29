import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/route/app_routes.dart';
import 'package:shamsoung/featurs/home/presentation/controller/home_controller.dart';
import 'package:shamsoung/featurs/notifications/presentation/controller/notification_controller.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

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
              "Hello, ${controller.customerName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.space5),
            Text("Welcome back to ShamSung", style: AppTextStyles.body),
          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.notifications),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
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
                            decoration: const BoxDecoration(
                              color: Colors.red,
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
