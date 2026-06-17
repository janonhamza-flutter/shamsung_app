import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../controller/my_requests_controller.dart';

class MyRequestsPage extends StatelessWidget {
  MyRequestsPage({super.key});

  final MyRequestsController controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      bottomNavigationBar: const BottomNavBar(currentIndex: 1),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,

        onPressed: () {
          Get.toNamed(AppRoutes.createRequest);
        },

        child: const Icon(Icons.add),
      ),

      appBar: AppBar(title: const Text("My Requests")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return const Center(
            child: Text(
              "No Requests Found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: controller.requests.length,

          itemBuilder: (context, index) {
            final request = controller.requests[index];

            return Card(
              color: AppColors.blue,
              margin: const EdgeInsets.only(bottom: 15),

              child: ListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.requestDetails, arguments: request.id);
                },

                title: Text(
                  request.deviceModel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 5),

                    Text(
                      request.trackingNumber,
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      request.status,
                      style: const TextStyle(color: Colors.green),
                    ),
                    /*  const SizedBox(height: 5),

                     Text(
   // request.shop.name,
    style: const TextStyle(color: Colors.white54),
  ),*/
                  ],
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
