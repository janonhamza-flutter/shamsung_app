import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsoung/featurs/home/presentation/widgets/bottom_nav_bar.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/exit_scope.dart';
import '../../../../../core/widgets/lottie_loading.dart';
import '../../../notifications/presentation/controller/notification_controller.dart';
import '../../../store/presentation/controllers/store_controller.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExitScope(
      child: Scaffold(
        backgroundColor: AppColors.darkBlue,
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
                          accent: AppColors.green,
                          onTap: () => Get.toNamed(AppRoutes.myOrders),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_rounded,
                          label: 'notifications'.tr,
                          accent: const Color(0xFF4FC3F7),
                          onTap: () => Get.toNamed(AppRoutes.notifications),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Preferences
                    _SectionLabel(label: 'preferences'.tr),
                    const SizedBox(height: 10),
                    _MenuCard(
                      items: [
                        _MenuItem(
                          icon: Icons.language_rounded,
                          label: 'language'.tr,
                          accent: const Color(0xFFFFB74D),
                          onTap: () => _showLanguageDialog(),
                        ),
                      ],
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
                          accent: const Color(0xFF80DEEA),
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

    showDialog(
      context: Get.context!,
      builder: (_) => Dialog(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFFFB74D).withValues(alpha: 0.3),
          ),
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
                  color: const Color(0xFFFFB74D).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: Color(0xFFFFB74D),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'select_language'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // English option
              _LanguageOption(
                label: 'English',
                flag: '🇬🇧',
                isSelected: currentLang == 'en',
                onTap: () {
                  Get.back();
                  storage.saveLanguage('en');
                  Get.updateLocale(const Locale('en', 'US'));
                  _refreshLangDependentData('en');
                },
              ),
              const SizedBox(height: 12),

              // Arabic option
              _LanguageOption(
                label: 'العربية',
                flag: '🇸🇦',
                isSelected: currentLang == 'ar',
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Language Option Tile
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageOption extends StatelessWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.isSelected,
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
              ? const Color(0xFFFFB74D).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFB74D).withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFFB74D) : Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFFFB74D),
                size: 20,
              ),
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
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.darkBlue],
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
                        gradient: const LinearGradient(
                          colors: [AppColors.green, Color(0xFF0FA84A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withValues(alpha: 0.35),
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
                          style: const TextStyle(
                            color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.6),
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.green, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
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
        color: Colors.white.withValues(alpha: 0.45),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.07),
                  indent: 68,
                ),
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
    return Column(
      children: [
        // Logout
        InkWell(
          onTap: () {
            showDialog(
              context: Get.context!,
              builder: (_) => Dialog(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                  ),
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
                          color: const Color(
                            0xFFFF9800,
                          ).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFFF9800),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'logout'.tr,
                        style: const TextStyle(
                          color: Colors.white,
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
                          color: Colors.white.withValues(alpha: 0.6),
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
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'cancel'.tr,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
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
                                backgroundColor: const Color(0xFFFF9800),
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
                                style: const TextStyle(
                                  color: Colors.white,
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
              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFF9800).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF9800),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'logout'.tr,
                  style: const TextStyle(
                    color: Color(0xFFFF9800),
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
              builder: (_) => Dialog(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
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
                          color: Colors.red.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'delete_account'.tr,
                        style: const TextStyle(
                          color: Colors.white,
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
                          color: Colors.white.withValues(alpha: 0.6),
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
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'cancel_delete'.tr,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
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
                                backgroundColor: Colors.red,
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
                                style: const TextStyle(
                                  color: Colors.white,
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
              color: Colors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'delete_account'.tr,
                  style: const TextStyle(
                    color: Colors.red,
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
