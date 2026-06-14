import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),

          onTap: () {
            controller.logout();
          },
        ),

        const SizedBox(height: 15),

        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),

          title: const Text(
            "Delete Account",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),

          onTap: () {
            Get.defaultDialog(
              title: "Delete Account",

              middleText: "Are you sure you want to delete your account?",

              textConfirm: "Delete",

              textCancel: "Cancel",

              confirmTextColor: Colors.white,

              onConfirm: () {
                Get.back();

                controller.deleteAccount();
              },
            );
          },
        ),
      ],
    );
  }
}
