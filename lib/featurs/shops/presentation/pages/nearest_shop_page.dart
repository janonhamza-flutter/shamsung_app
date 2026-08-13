import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/shop_model.dart';
import '../controllers/nearest_shop_controller.dart';

class NearestShopPage extends StatelessWidget {
  NearestShopPage({super.key});

  final NearestShopController controller = Get.put(NearestShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.colors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'nearest_shops_title'.tr,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.fetchNearest,
              icon: Icon(
                Icons.refresh_rounded,
                color: controller.isLoading.value
                    ? context.colors.textDisabled
                    : context.colors.accent,
              ),
              tooltip: 'refresh'.tr,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return const _LoadingState();
          if (!controller.hasSearched.value) {
            return _ErrorState(onRetry: controller.fetchNearest);
          }
          if (controller.shops.isEmpty) {
            return _EmptyState(onRetry: controller.fetchNearest);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            itemCount: controller.shops.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ResultsHeader(count: controller.shops.length),
                );
              }
              final shop = controller.shops[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ShopCard(
                  shop: shop,
                  distanceLabel: controller.distanceLabel(shop),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.colors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colors.accent.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: context.colors.accent,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'detecting_location'.tr,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'finding_nearest_shops'.tr,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_rounded,
              color: context.colors.textDisabled,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'could_not_get_location'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'enable_location_services'.tr,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                color: context.colors.textOnPrimary,
              ),
              label: Text(
                'try_again'.tr,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              color: context.colors.textDisabled,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'no_shops_found_nearby'.tr,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_shops_near_location'.tr,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                color: context.colors.textOnPrimary,
              ),
              label: Text(
                'refresh'.tr,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Results header
// ─────────────────────────────────────────────────────────────────────────────

class _ResultsHeader extends StatelessWidget {
  final int count;
  const _ResultsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_rounded,
          color: context.colors.accent,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          '$count ${count == 1 ? 'shops_found_near_you'.tr : 'shops_found_near_you_plural'.tr}',
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shop Card
// ─────────────────────────────────────────────────────────────────────────────

class _ShopCard extends StatelessWidget {
  final ShopModel shop;
  final String? distanceLabel;

  const _ShopCard({required this.shop, this.distanceLabel});

  @override
  Widget build(BuildContext context) {
    final bool closed = !shop.isActive;

    return Opacity(
      // الصالات المغلقة تظهر بشفافية أقل
      opacity: closed ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(20),
          // حد رمادي للصالات المغلقة بدل الشكل العادي
          border: closed
              ? Border.all(color: context.colors.border, width: 1)
              : null,
          boxShadow: closed
              ? null
              : [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  // الصورة أو placeholder
                  if (shop.imageUrl != null)
                    _buildImage(context, shop.imageUrl!, closed)
                  else
                    _imagePlaceholder(context, closed),

                  // ── Distance badge — أعلى اليسار ──────────────
                  if (distanceLabel != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          // ثابت داكن فوق الصورة لضمان وضوح النص بغض النظر
                          // عن الثيم — شارة فوق صورة وليست سطحاً في الصفحة
                          color: context.colors.overlay,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.near_me_rounded,
                              color: context.colors.accent,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distanceLabel!,
                              style: TextStyle(
                                color: context.colors.textOnPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── Open / Closed badge — أعلى اليمين ──────────
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // شارة فوق صورة — الأحمر/الأخضر الدلاليان يبقيان
                        // كما هما فوق الصورة بغض النظر عن الثيم
                        color: closed
                            ? context.colors.overlay
                            : context.colors.success.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            closed
                                ? Icons.lock_outline_rounded
                                : Icons.check_circle_outline_rounded,
                            color: context.colors.textOnPrimary,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            closed ? 'shop_closed'.tr : 'shop_open'.tr,
                            style: TextStyle(
                              color: context.colors.textOnPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + star rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: TextStyle(
                            color: closed
                                ? context.colors.textDisabled
                                : context.colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ── Star rating ────────────────────────────
                      _StarRating(rating: shop.rating, muted: closed),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: closed
                            ? context.colors.textDisabled
                            : context.colors.textSecondary,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address,
                          style: TextStyle(
                            color: closed
                                ? context.colors.textDisabled
                                : context.colors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Phone
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: closed
                            ? context.colors.textDisabled
                            : context.colors.textSecondary,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.phone,
                        style: TextStyle(
                          color: closed
                              ? context.colors.textDisabled
                              : context.colors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // ── Action buttons — مخفية للصالات المغلقة ──────
                  if (!closed) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.build_rounded,
                            label: 'request_repair'.tr,
                            color: context.colors.accent,
                            onTap: () => Get.toNamed(
                              AppRoutes.createRequest,
                              arguments: {
                                'shopId': shop.id,
                                'shopName': shop.name,
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.storefront_rounded,
                            label: 'shop_here'.tr,
                            color: const Color(0xFF1565C0),
                            onTap: () => Get.toNamed(
                              AppRoutes.store,
                              arguments: {
                                'shopId': shop.id,
                                'shopName': shop.name,
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    // رسالة توضيحية للمغلقة
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Text(
                        'branch_unavailable'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.textDisabled,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String url, bool closed) {
    final img = Image.network(
      url,
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 150,
          color: context.colors.surfaceVariant,
          child: Center(
            child: CircularProgressIndicator(
              color: context.colors.accent,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _imagePlaceholder(context, closed),
    );

    // grayscale فقط للصالات المغلقة
    if (closed) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: img,
      );
    }
    return img;
  }

  Widget _imagePlaceholder(BuildContext context, bool closed) {
    return Container(
      height: 150,
      width: double.infinity,
      color: context.colors.surfaceVariant,
      child: Icon(
        Icons.store_mall_directory_outlined,
        color: context.colors.textDisabled,
        size: 52,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Star Rating widget
// ─────────────────────────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  final double rating; // 0.0 – 5.0
  final bool muted;

  const _StarRating({required this.rating, this.muted = false});

  @override
  Widget build(BuildContext context) {
    // Amber stays fixed in both themes — a universal "rating star" color
    // that reads clearly on light and dark surfaces alike.
    final starColor = muted ? context.colors.textDisabled : Colors.amber;
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // نجوم
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            if (i < full) {
              return Icon(Icons.star_rounded, color: starColor, size: 15);
            } else if (i == full && hasHalf) {
              return Icon(Icons.star_half_rounded, color: starColor, size: 15);
            } else {
              return Icon(
                Icons.star_outline_rounded,
                color: starColor.withAlpha(100),
                size: 15,
              );
            }
          }),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: muted
                ? context.colors.textDisabled
                : context.colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      icon: Icon(icon, color: context.colors.textOnPrimary, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: context.colors.textOnPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
