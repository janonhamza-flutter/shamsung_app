import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/shop_model.dart';
import '../controllers/nearest_shop_controller.dart';

class NearestShopPage extends StatelessWidget {
  NearestShopPage({super.key});

  final NearestShopController controller = Get.put(NearestShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'nearest_shops_title'.tr,
          style: const TextStyle(
            color: Colors.white,
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
                    ? Colors.white24
                    : AppColors.green,
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
              color: AppColors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.green.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'detecting_location'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'finding_nearest_shops'.tr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
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
            const Icon(
              Icons.location_off_rounded,
              color: Colors.white24,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'could_not_get_location'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'enable_location_services'.tr,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'try_again'.tr,
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
            const Icon(
              Icons.store_mall_directory_outlined,
              color: Colors.white24,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'no_shops_found_nearby'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_shops_near_location'.tr,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'refresh'.tr,
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
        const Icon(Icons.location_on_rounded, color: AppColors.green, size: 18),
        const SizedBox(width: 6),
        Text(
          '$count ${count == 1 ? 'shops_found_near_you'.tr : 'shops_found_near_you_plural'.tr}',
          style: const TextStyle(
            color: Colors.white70,
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
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(20),
          // حد رمادي للصالات المغلقة بدل الشكل العادي
          border: closed ? Border.all(color: Colors.white12, width: 1) : null,
          boxShadow: closed
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
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
                    _buildImage(shop.imageUrl!, closed)
                  else
                    _imagePlaceholder(closed),

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
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              color: AppColors.green,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distanceLabel!,
                              style: const TextStyle(
                                color: Colors.white,
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
                        color: closed
                            ? Colors.black.withValues(alpha: 0.65)
                            : AppColors.green.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            closed
                                ? Icons.lock_outline_rounded
                                : Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            closed ? 'shop_closed'.tr : 'shop_open'.tr,
                            style: const TextStyle(
                              color: Colors.white,
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
                            color: closed ? Colors.white54 : Colors.white,
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
                        color: closed ? Colors.white24 : Colors.white54,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address,
                          style: TextStyle(
                            color: closed ? Colors.white38 : Colors.white60,
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
                        color: closed ? Colors.white24 : Colors.white54,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.phone,
                        style: TextStyle(
                          color: closed ? Colors.white38 : Colors.white60,
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
                            color: AppColors.green,
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
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        'branch_unavailable'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white38,
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

  Widget _buildImage(String url, bool closed) {
    final img = Image.network(
      url,
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 150,
          color: const Color(0xFF0D3D8A),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.green,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _imagePlaceholder(closed),
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

  Widget _imagePlaceholder(bool closed) {
    return Container(
      height: 150,
      width: double.infinity,
      color: closed ? const Color(0xFF1A1A2E) : const Color(0xFF0D3D8A),
      child: Icon(
        Icons.store_mall_directory_outlined,
        color: closed ? Colors.white12 : Colors.white24,
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
    final starColor = muted ? Colors.white24 : Colors.amber;
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
            color: muted ? Colors.white24 : Colors.white70,
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
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
