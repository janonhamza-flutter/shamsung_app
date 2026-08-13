import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_palette.dart';

/// Returns [darkColor] unchanged in Dark Mode; in Light Mode returns
/// [lightColor], a deepened variant tuned for legibility on light surfaces.
/// Used for one-off decorative feature accents that don't map onto a
/// semantic palette field (see profile_page.dart for the same pattern).
Color _accent(BuildContext context, Color darkColor, Color lightColor) {
  return context.colors.isDark ? darkColor : lightColor;
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar and hero header are kept as fixed brand-navy chrome in both
    // themes (same judgment call as profile_page.dart's _ProfileHeader) —
    // the content cards below adapt fully to Light/Dark Mode.
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'about_app_title'.tr,
          style: TextStyle(
            color: context.colors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: context.colors.textOnPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.primary, context.colors.primaryDark],
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
                      color: context.colors.accent.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.accent.withValues(alpha: 0.25),
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
                    style: TextStyle(
                      color: context.colors.textOnPrimary,
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
                      color: context.colors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.colors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${'version'.tr} 1.0.0',
                      style: TextStyle(
                        color: context.colors.accent,
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
                          accent: context.colors.accent,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'about_shamsung_desc'.tr,
                          style: TextStyle(
                            color: context.colors.textSecondary,
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
                          accent: context.colors.warning,
                        ),
                        const SizedBox(height: 14),
                        _FeatureRow(
                          icon: Icons.build_rounded,
                          accent: context.colors.accent,
                          label: 'feature_maintenance'.tr,
                          desc: 'feature_maintenance_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.storefront_rounded,
                          accent: context.colors.warning,
                          label: 'feature_store'.tr,
                          desc: 'feature_store_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.chat_bubble_rounded,
                          accent: _accent(
                            context,
                            const Color(0xFFCE93D8),
                            const Color(0xFF7B1FA2),
                          ),
                          label: 'feature_ai'.tr,
                          desc: 'feature_ai_desc'.tr,
                        ),
                        _FeatureRow(
                          icon: Icons.location_on_rounded,
                          accent: context.colors.info,
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
                          accent: context.colors.info,
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
                            color: context.colors.textDisabled,
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: context.colors.isDark
            ? null
            : Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
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
          style: TextStyle(
            color: context.colors.textPrimary,
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
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) Divider(height: 20, color: context.colors.divider),
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
                color: context.colors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (!isLast) Divider(height: 16, color: context.colors.divider),
      ],
    );
  }
}
