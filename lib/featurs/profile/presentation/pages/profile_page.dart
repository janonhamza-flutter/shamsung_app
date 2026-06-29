import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:shamsoung/featurs/profile/presentation/widgets/profile_header.dart';
import 'package:shamsoung/featurs/profile/presentation/widgets/profile_logout_section.dart';
import 'package:shamsoung/featurs/profile/presentation/widgets/profile_tile.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';

import '../../../../core/route/app_routes.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      bottomNavigationBar: const BottomNavBar(currentIndex: 2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),

          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (controller.customer.value == null) {
                    return const CircularProgressIndicator();
                  }
                  return ProfileHeader(
                    name: controller.customer.value == null
                        ? ""
                        : "${controller.customer.value!.firstName} ${controller.customer.value!.lastName}",

                    email: controller.customer.value?.email ?? "",
                  );
                }),

                const SizedBox(height: 30),

                ProfileTile(
                  icon: Icons.edit_outlined,
                  title: "Edit Profile",
                  onTap: () {},
                ),

                /*   ProfileTile(
                  icon: Icons.inventory_2_outlined,
                  title: "My Orders",
                  onTap: () {},
                ),*/
                ProfileTile(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  onTap: () {},
                ),

                ProfileTile(
                  icon: Icons.notifications_none,
                  title: "Language",
                  onTap: () {},
                ),

                /*  ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: "Nearby Shops",
                  onTap: () {},
                ),

                ProfileTile(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  onTap: () {},
                ),*/
                ProfileTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  onTap: () {},
                ),

                ProfileTile(
                  icon: Icons.info_outline,
                  title: "About App",
                  onTap: () {
                    Get.to(Get.toNamed(AppRoutes.about));
                  },
                ),

                const SizedBox(height: 30),

                ProfileLogoutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
