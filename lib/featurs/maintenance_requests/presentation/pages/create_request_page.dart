import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/create_request_controller.dart';

class CreateRequestPage extends StatelessWidget {
  CreateRequestPage({super.key});

  final CreateRequestController controller = Get.put(CreateRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      appBar: AppBar(title: const Text("Create Request")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: controller.deviceController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Device Model",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.problemController,
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Problem Description",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),

                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => DropdownButton<int>(
                value: controller.selectedShopId.value,
                isExpanded: true,
                dropdownColor: AppColors.darkBlue,
                style: const TextStyle(color: Colors.white, fontSize: 16),

                iconEnabledColor: Colors.white,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      "Main Shop",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                onChanged: (value) {
                  controller.selectedShopId.value = value!;
                },
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.createRequest,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
