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
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Get.offNamed(AppRoutes.home);
            break;
          case 1:
            Get.offNamed(AppRoutes.myRequests);
            break;
          case 2:
            Get.offNamed(AppRoutes.store);
            break;
          case 3:
            Get.offNamed(AppRoutes.profile);
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.build), label: ""),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
