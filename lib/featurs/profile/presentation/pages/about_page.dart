import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'about_app_title'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue, AppColors.darkBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withValues(alpha: 0.25),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'app_name'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.green.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${'version'.tr} 1.0.0',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About card
                  _InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          icon: Icons.info_rounded,
                          label: 'about_shamsung_label'.tr,
                          accent: AppColors.green,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'about_shamsung_desc'.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Features
                  _InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          icon: Icons.star_rounded,
                          label: 'key_features'.tr,
                          accent: const Color(0xFFFFB74D),
                        ),
                        const SizedBox(height: 14),
                        _FeatureRow(
                          icon: Icons.build_rounded,
                          accent: AppColors.green,
                          label: 'feature_maintenance'.tr,
                          desc: 'feature_maintenance_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.storefront_rounded,
                          accent: const Color(0xFFFFB74D),
                          label: 'feature_store'.tr,
                          desc: 'feature_store_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.chat_bubble_rounded,
                          accent: const Color(0xFFCE93D8),
                          label: 'feature_ai'.tr,
                          desc: 'feature_ai_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.location_on_rounded,
                          accent: const Color(0xFF4FC3F7),
                          label: 'feature_nearest'.tr,
                          desc: 'feature_nearest_desc'.tr,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // App info
                  _InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          icon: Icons.code_rounded,
                          label: 'app_info'.tr,
                          accent: const Color(0xFF4FC3F7),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'app_info_name'.tr,
                          value: 'app_name'.tr,
                        ),
                        _DetailRow(
                          label: 'app_info_platform'.tr,
                          value: 'app_info_platform_value'.tr,
                        ),
                        _DetailRow(
                          label: 'app_info_version'.tr,
                          value: '1.0.0',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Footer
                  SafeArea(
                    top: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'app_footer'.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  const _CardTitle({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: accent, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String label;
  final String desc;
  final bool isLast;

  const _FeatureRow({
    required this.icon,
    required this.accent,
    required this.label,
    required this.desc,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Divider(height: 20, color: Colors.white.withValues(alpha: 0.07)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (!isLast)
          Divider(height: 16, color: Colors.white.withValues(alpha: 0.07)),
      ],
    );
  }
}
