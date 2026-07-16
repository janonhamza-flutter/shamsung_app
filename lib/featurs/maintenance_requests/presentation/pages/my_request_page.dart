import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/exit_scope.dart';
import '../../../home/presentation/widgets/bottom_nav_bar.dart';
import '../controller/my_requests_controller.dart';
import '../widgets/request_card_widget.dart';

class MyRequestsPage extends StatelessWidget {
  MyRequestsPage({super.key});

  final MyRequestsController controller = Get.put(MyRequestsController());

  @override
  Widget build(BuildContext context) {
    return ExitScope(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.green,
          onPressed: () => Get.toNamed(AppRoutes.createRequest),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'new_request'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'my_requests'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) return _buildLoadingState();
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(controller.errorMessage.value);
          }
          if (controller.requests.isEmpty) return _buildEmptyState();
          return _buildRequestsList();
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading.json',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
            repeat: true,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(const ['**'], value: AppColors.green),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'loading_requests'.tr,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white24,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white54, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.getRequests,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.build_circle_outlined,
                color: AppColors.green,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'no_requests_yet'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_requests_hint'.tr,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.createRequest),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                'create_request'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    return RefreshIndicator(
      color: AppColors.green,
      backgroundColor: AppColors.blue,
      onRefresh: controller.getRequests,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.padding,
          AppSizes.space15,
          AppSizes.padding,
          100,
        ),
        itemCount: controller.requests.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RequestCardWidget(request: controller.requests[index]),
        ),
      ),
    );
  }
}
