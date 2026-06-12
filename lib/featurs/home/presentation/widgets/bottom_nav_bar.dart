import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/route/app_routes.dart';

import '../../../../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.blue,

      selectedItemColor: Colors.white,

      unselectedItemColor: Colors.grey,

      currentIndex: currentIndex,

      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Get.offNamed(AppRoutes.home);
            break;

          case 1:
            // Services Page لاحقاً
            break;

          case 2:
            Get.toNamed(AppRoutes.profile);
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),

        BottomNavigationBarItem(icon: Icon(Icons.build), label: ""),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
