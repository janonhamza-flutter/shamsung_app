import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/core/constants/app_strings.dart';

import '../controller/profile_controller.dart';

class ProfileLogoutSection extends StatelessWidget {
  ProfileLogoutSection({super.key});
  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.orange),

          title: Text(
            AppStrings.logout,
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),

          onTap: () {
            controller.logout();
          },
        ),

        const SizedBox(height: 15),

        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),

          title: Text(
            AppStrings.deleteAccount,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),

          onTap: () {
            Get.defaultDialog(
              title: AppStrings.deleteAccount,

              middleText: AppStrings.sureDelete,

              textConfirm: AppStrings.confirmDelete,

              textCancel: AppStrings.cancelDelete,

              confirmTextColor: Colors.white,

              onConfirm: () async {
                Get.back();

                await controller.deleteAccount();
              },
            );
          },
        ),
      ],
    );
  }
}
