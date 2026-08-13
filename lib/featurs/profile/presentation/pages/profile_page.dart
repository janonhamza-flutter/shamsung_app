import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/home/presentation/widgets/bottom_nav_bar.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/theme_controller.dart';
import '../../../../../core/widgets/exit_scope.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../../../notifications/presentation/controller/notification_controller.dart';
import '../../../store/presentation/controllers/store_controller.dart';
import '../controller/profile_controller.dart';

/// Returns [darkColor] unchanged in Dark Mode; in Light Mode returns
/// [lightColor], a deepened variant tuned for legibility on light surfaces.
/// Used for the menu's decorative per-category icon accents, which aren't
/// status colors and so don't map onto the semantic palette fields.
Color _accent(BuildContext context, Color darkColor, Color lightColor) {
  return context.colors.isDark ? darkColor : lightColor;
}

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.find();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExitScope(
      child: Scaffold(
        backgroundColor: context.colors.background,
        bottomNavigationBar: const BottomNavBar(currentIndex: 3),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Section ──────────────────────────────────
              Obx(() {
                final c = controller.customer.value;
                return _ProfileHeader(
                  firstName: c?.firstName ?? '',
                  lastName: c?.lastName ?? '',
                  email: c?.email ?? '',
                  phone: c?.phone ?? '',
                  isLoading: controller.isLoading.value && c == null,
                );
              }),

              // ── Menu Sections ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account
                    _SectionLabel(label: 'account'.tr),
                    const SizedBox(height: 10),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.inventory_2_rounded,
                          label: 'my_orders'.tr,
                          accent: context.colors.accent,
                          onTap: () => Get.toNamed(AppRoutes.myOrders),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_rounded,
                          label: 'notifications'.tr,
                          accent: context.colors.info,
                          onTap: () => Get.toNamed(AppRoutes.notifications),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Preferences
                    _SectionLabel(label: 'preferences'.tr),
                    const SizedBox(height: 10),
                    Obx(
                      () => _MenuCard(
                        items: [
                          _MenuItem(
                            icon: Icons.language_rounded,
                            label: 'language'.tr,
                            accent: _accent(
                              context,
                              const Color(0xFFFFB74D),
                              const Color(0xFFB4650A),
                            ),
                            onTap: () => _showLanguageDialog(),
                          ),
                          _MenuItem(
                            icon: themeController.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            label: 'appearance'.tr,
                            accent: _accent(
                              context,
                              const Color(0xFFB39DDB),
                              const Color(0xFF6A4EE0),
                            ),
                            onTap: () => _showThemeDialog(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // More
                    _SectionLabel(label: 'more'.tr),
                    const SizedBox(height: 10),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.info_rounded,
                          label: 'about_app'.tr,
                          accent: _accent(
                            context,
                            const Color(0xFF80DEEA),
                            const Color(0xFF0E7C86),
                          ),
                          onTap: () => Get.toNamed(AppRoutes.about),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Danger Zone
                    _DangerSection(controller: controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final storage = StorageService();
    final currentLang = storage.getLanguage();
    final ctx = Get.context!;
    final accentColor = _accent(
      ctx,
      const Color(0xFFFFB74D),
      const Color(0xFFB4650A),
    );

    showDialog(
      context: ctx,
      builder: (dialogContext) => Dialog(
        backgroundColor: dialogContext.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.language_rounded, color: accentColor, size: 30),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'select_language'.tr,
                style: TextStyle(
                  color: dialogContext.colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // English option
              _OptionTile(
                label: 'English',
                leading: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
                isSelected: currentLang == 'en',
                accentColor: accentColor,
                onTap: () {
                  Get.back();
                  storage.saveLanguage('en');
                  Get.updateLocale(const Locale('en', 'US'));
                  _refreshLangDependentData('en');
                },
              ),
              const SizedBox(height: 12),

              // Arabic option
              _OptionTile(
                label: 'العربية',
                leading: const Text('🇸🇦', style: TextStyle(fontSize: 22)),
                isSelected: currentLang == 'ar',
                accentColor: accentColor,
                onTap: () {
                  Get.back();
                  storage.saveLanguage('ar');
                  Get.updateLocale(const Locale('ar', 'SA'));
                  _refreshLangDependentData('ar');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// إعادة جلب البيانات التي تعتمد على اللغة بعد تغييرها
  /// [lang] هي اللغة الجديدة المختارة — تُمرَّر مباشرةً لتجنب race condition مع Get.locale
  void _refreshLangDependentData(String lang) {
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications(lang: lang);
    }
    if (Get.isRegistered<StoreController>()) {
      Get.find<StoreController>().fetchAccessories(lang: lang);
    }
  }

  void _showThemeDialog() {
    final ctx = Get.context!;
    final currentMode = themeController.themeMode.value;
    final accentColor = _accent(
      ctx,
      const Color(0xFFB39DDB),
      const Color(0xFF6A4EE0),
    );

    showDialog(
      context: ctx,
      builder: (dialogContext) => Dialog(
        backgroundColor: dialogContext.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.dark_mode_rounded,
                  color: accentColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'select_theme'.tr,
                style: TextStyle(
                  color: dialogContext.colors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _OptionTile(
                label: 'theme_light'.tr,
                leading: Icon(
                  Icons.light_mode_rounded,
                  color: accentColor,
                  size: 22,
                ),
                isSelected: currentMode == ThemeMode.light,
                accentColor: accentColor,
                onTap: () {
                  Get.back();
                  themeController.setThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(height: 12),

              _OptionTile(
                label: 'theme_dark'.tr,
                leading: Icon(
                  Icons.dark_mode_rounded,
                  color: accentColor,
                  size: 22,
                ),
                isSelected: currentMode == ThemeMode.dark,
                accentColor: accentColor,
                onTap: () {
                  Get.back();
                  themeController.setThemeMode(ThemeMode.dark);
                },
              ),
              const SizedBox(height: 12),

              _OptionTile(
                label: 'theme_system'.tr,
                leading: Icon(
                  Icons.brightness_auto_rounded,
                  color: accentColor,
                  size: 22,
                ),
                isSelected: currentMode == ThemeMode.system,
                accentColor: accentColor,
                onTap: () {
                  Get.back();
                  themeController.setThemeMode(ThemeMode.system);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Generic selectable option row — used by the language & theme dialogs.
// ─────────────────────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final Widget leading;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.leading,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.15)
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? accentColor.withValues(alpha: 0.6)
                : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? accentColor : context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Header
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isLoading;

  const _ProfileHeader({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Kept as a fixed brand-navy banner in both themes — the header stays
    // on-brand chrome while the content below it adapts to Light/Dark Mode.
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.primaryDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: LottieLoading(),
                  ),
                )
              : Column(
                  children: [
                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            context.colors.accent,
                            const Color(0xFF0FA84A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.accent.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          firstName.isNotEmpty
                              ? firstName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: context.colors.textOnPrimary,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        color: context.colors.textOnPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Email
                    Text(
                      email,
                      style: TextStyle(
                        color: context.colors.textOnPrimary.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info chips row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (phone.isNotEmpty)
                          _InfoChip(icon: Icons.phone_rounded, label: phone),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: context.colors.textOnPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.textOnPrimary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.colors.accent, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: context.colors.textOnPrimary.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Menu Card
// ─────────────────────────────────────────────────────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(18) : Radius.zero,
                  bottom: i == items.length - 1
                      ? const Radius.circular(18)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.accent, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.colors.textDisabled,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(height: 1, color: context.colors.divider, indent: 68),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Danger Section (Logout + Delete)
// ─────────────────────────────────────────────────────────────────────────────

class _DangerSection extends StatelessWidget {
  final ProfileController controller;
  const _DangerSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final warningColor = _accent(
      context,
      const Color(0xFFFF9800),
      const Color(0xFFB25F00),
    );
    final errorColor = context.colors.error;

    return Column(
      children: [
        // Logout
        InkWell(
          onTap: () {
            showDialog(
              context: Get.context!,
              builder: (dialogContext) => Dialog(
                backgroundColor: dialogContext.colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: warningColor.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: warningColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: warningColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'logout'.tr,
                        style: TextStyle(
                          color: dialogContext.colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Message
                      Text(
                        'logout_confirm'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: dialogContext.colors.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                side: BorderSide(
                                  color: dialogContext.colors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'cancel'.tr,
                                style: TextStyle(
                                  color: dialogContext.colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Confirm Logout
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Get.back();
                                await controller.logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: warningColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'logout'.tr,
                                style: TextStyle(
                                  color: dialogContext.colors.textOnPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: warningColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: warningColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  'logout'.tr,
                  style: TextStyle(
                    color: warningColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Delete Account
        InkWell(
          onTap: () {
            showDialog(
              context: Get.context!,
              builder: (dialogContext) => Dialog(
                backgroundColor: dialogContext.colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: errorColor.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: errorColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: errorColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'delete_account'.tr,
                        style: TextStyle(
                          color: dialogContext.colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Message
                      Text(
                        'sure_delete'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: dialogContext.colors.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                side: BorderSide(
                                  color: dialogContext.colors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'cancel_delete'.tr,
                                style: TextStyle(
                                  color: dialogContext.colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Confirm Delete
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Get.back();
                                await controller.deleteAccount();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: errorColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'confirm_delete'.tr,
                                style: TextStyle(
                                  color: dialogContext.colors.textOnPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: errorColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever_rounded,
                  color: errorColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'delete_account'.tr,
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
