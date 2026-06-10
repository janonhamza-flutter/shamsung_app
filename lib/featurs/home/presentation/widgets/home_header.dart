import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/home/presentation/controller/home_controller.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>(); //

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        /// =========================
        /// USER INFO
        /// =========================
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Hello, ${controller.customerName}",
              style: AppTextStyles.authTitle,
            ),

            SizedBox(height: AppSizes.space5),

            Text("Welcome back to ShamSung", style: AppTextStyles.body),
          ],
        ),

        /// =========================
        /// NOTIFICATION
        /// =========================
        Container(
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

              /// RED DOT
              Positioned(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
