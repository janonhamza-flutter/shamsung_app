import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';

import '../../../../core/route/app_routes.dart';
import '../../data/dummy/dummy_orders.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/order_card.dart';

import '../widgets/section_title.dart';
import '../widgets/service_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      bottomNavigationBar: const BottomNavBar(currentIndex: 0),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// =========================
              /// HEADER
              /// =========================
              const HomeHeader(),

              const SizedBox(height: AppSizes.space30),

              /// create request
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 15),

                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.createRequest);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  child: const Text(
                    "Create Maintenance Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.space30),

              /// =========================
              /// SERVICES TITLE
              /// =========================
              const SectionTitle(title: "Services"),

              const SizedBox(height: AppSizes.space20),

              /// =========================
              /// SERVICES LIST
              /// =========================
              SizedBox(
                height: 140,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: const [
                    ServiceCard(icon: Icons.phone_android, title: "Screen"),

                    SizedBox(width: 15),

                    ServiceCard(
                      icon: Icons.battery_charging_full,

                      title: "Battery",
                    ),

                    SizedBox(width: 15),

                    ServiceCard(
                      icon: Icons.camera_alt_outlined,

                      title: "Camera",
                    ),

                    SizedBox(width: 15),

                    ServiceCard(
                      icon: Icons.volume_up_outlined,

                      title: "Speaker",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.space30),

              /// =========================
              /// ORDERS TITLE
              /// =========================
              const SectionTitle(title: "My Orders"),

              const SizedBox(height: AppSizes.space20),

              /// =========================
              /// ORDERS LIST
              /// =========================
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,

                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),

                      child: OrderCard(
                        phoneName: order.phoneName,

                        repairType: order.repairType,

                        status: order.status,

                        image: order.image,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
