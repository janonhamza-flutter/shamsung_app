import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
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
        backgroundColor: context.colors.background,
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: context.colors.accent,
          onPressed: () => Get.toNamed(AppRoutes.createRequest),
          icon: Icon(Icons.add_rounded, color: context.colors.textOnPrimary),
          label: Text(
            'new_request'.tr,
            style: TextStyle(
              color: context.colors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: context.colors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'my_requests'.tr,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) return _buildLoadingState(context);
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(context, controller.errorMessage.value);
          }
          if (controller.requests.isEmpty) return _buildEmptyState(context);
          return _buildRequestsList(context);
        }),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
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
                ValueDelegate.color(
                  const ['**'],
                  value: context.colors.accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'loading_requests'.tr,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: context.colors.textDisabled,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.getRequests,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.refresh, color: context.colors.textOnPrimary),
              label: Text(
                'retry'.tr,
                style: TextStyle(color: context.colors.textOnPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: context.colors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.build_circle_outlined,
                color: context.colors.accent,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'no_requests_yet'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_requests_hint'.tr,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.createRequest),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(Icons.add_rounded, color: context.colors.textOnPrimary),
              label: Text(
                'create_request'.tr,
                style: TextStyle(
                  color: context.colors.textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.accent,
      backgroundColor: context.colors.surface,
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
