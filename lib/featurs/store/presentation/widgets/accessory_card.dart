import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../data/models/accessory_model.dart';

class AccessoryCard extends StatelessWidget {
  final AccessoryModel accessory;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final bool isAdding; // true while POST /cart is in flight

  const AccessoryCard({
    super.key,
    required this.accessory,
    required this.onTap,
    required this.onAddToCart,
    this.isAdding = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = accessory.stockQuantity == 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: context.colors.isDark
              ? null
              : Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: accessory.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: accessory.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                const _CardPlaceholder(loading: true),
                            errorWidget: (_, __, ___) =>
                                const _CardPlaceholder(),
                          )
                        : const _CardPlaceholder(),
                  ),
                  // Out of stock overlay
                  if (outOfStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.overlay,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'out_of_stock'.tr,
                            style: TextStyle(
                              color: context.colors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accessory.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${accessory.price.toStringAsFixed(2)} ${'currency'.tr}',
                        style: TextStyle(
                          color: context.colors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // Add to cart button — shows spinner while API call is in flight
                      GestureDetector(
                        onTap: (outOfStock || isAdding) ? null : onAddToCart,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: outOfStock
                                ? context.colors.textDisabled.withValues(
                                    alpha: 0.2,
                                  )
                                : context.colors.accent.withValues(
                                    alpha: 0.15,
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: isAdding
                              ? Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    color: context.colors.accent,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.add_shopping_cart_outlined,
                                  size: 18,
                                  color: outOfStock
                                      ? context.colors.textDisabled
                                      : context.colors.accent,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  final bool loading;
  const _CardPlaceholder({this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: context.colors.surfaceVariant,
      child: Center(
        child: loading
            ? CircularProgressIndicator(
                color: context.colors.accent,
                strokeWidth: 2,
              )
            : Icon(
                Icons.image_outlined,
                color: context.colors.textDisabled,
                size: 36,
              ),
      ),
    );
  }
}
