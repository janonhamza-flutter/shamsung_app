import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controller/consultation_controller.dart';
import '../widgets/consultation_card.dart';

class ConsultationListPage extends StatelessWidget {
  const ConsultationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsultationController>();

    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: const Text(
          'My Consultations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.fetchConsultations,
          ),
        ],
      ),

      // ── FAB — new consultation ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.createConsultation),
        backgroundColor: AppColors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        if (controller.consultations.isEmpty) {
          return _EmptyState(
            onTap: () => Get.toNamed(AppRoutes.createConsultation),
          );
        }

        return RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.blue,
          onRefresh: controller.fetchConsultations,
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(AppSizes.padding),
              itemCount: controller.consultations.length,
              itemBuilder: (_, index) {
                // كل card تستمع مباشرة للتغييرات في العنصر
                final c = controller.consultations[index];
                return ConsultationCard(consultation: c);
              },
            ),
          ),
        );
      }),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.green.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 52,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No consultations yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ask AI or a technician\nabout your device issue',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Start a Consultation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
