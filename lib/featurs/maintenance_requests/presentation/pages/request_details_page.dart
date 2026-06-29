/*import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../core/theme/app_colors.dart';

class RequestDetailsPage extends StatelessWidget {
   RequestDetailsPage({super.key});

   final int requestId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print("REQUEST ID = $requestId");
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      appBar: AppBar(title: const Text("Request Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildCard(title: "Tracking Number", value: "SHM-D9EQPFV3"),

            _buildCard(
              title: "Device Model",
              value: "Samsung Galaxy S24 Ultra",
            ),

            _buildCard(
              title: "Problem Description",
              value: "الشاشة مكسورة ولا تستجيب للمس",
            ),

            _buildCard(title: "Status", value: "waiting_customer_approval"),

            _buildCard(title: "Estimated Days", value: "3"),

            const SizedBox(height: 20),

            const Text(
              "Shop Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _buildCard(title: "Name", value: "صالة المزة الرئيسية"),

            _buildCard(title: "Address", value: "طريق المزة، دمشق"),

            _buildCard(title: "Phone", value: "0112345678"),

            const SizedBox(height: 20),

            const Text(
              "Required Parts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: AppColors.blue,

              child: ListTile(
                title: const Text(
                  "شاشة Samsung Galaxy S24 Ultra",
                  style: TextStyle(color: Colors.white),
                ),

                subtitle: const Text(
                  "150 \$",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            Card(
              color: AppColors.blue,

              child: ListTile(
                title: const Text(
                  "بطارية أصلية",
                  style: TextStyle(color: Colors.white),
                ),

                subtitle: const Text(
                  "45 \$",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String value}) {
    return Card(
      color: AppColors.blue,

      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white70)),

        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/request_details_controller.dart';

class RequestDetailsPage extends StatelessWidget {
  RequestDetailsPage({super.key});

  final controller = Get.put(RequestDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final request = controller.request;

        return ListView(
          padding: const EdgeInsets.all(20),

          children: [
            Text(
              request["tracking_number"] ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text("Device: ${request["device_model"]}"),

            const SizedBox(height: 10),

            Text("Problem: ${request["problem_description"]}"),

            const SizedBox(height: 10),

            Text("Status: ${request["status"]}"),

            const SizedBox(height: 10),

            Text("Customer Status: ${request["customer_status"]}"),
          ],
        );
      }),
    );
  }
}
