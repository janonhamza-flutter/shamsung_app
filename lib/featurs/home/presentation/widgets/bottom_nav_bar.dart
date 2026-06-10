import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.blue,

      selectedItemColor: Colors.white,

      unselectedItemColor: Colors.grey,

      currentIndex: 0,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),

        BottomNavigationBarItem(icon: Icon(Icons.build), label: ""),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
    );
  }
}
