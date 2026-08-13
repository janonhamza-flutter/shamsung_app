import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../data/models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final bool isLoading; // true while any API call is in flight for this item

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLoading ? 0.6 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: context.colors.isDark
              ? null
              : Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            // ── Thumbnail ──────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: item.accessory.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.accessory.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholder(context),
                        errorWidget: (_, __, ___) => _placeholder(context),
                      )
                    : _placeholder(context),
              ),
            ),
            const SizedBox(width: 12),

            // ── Details ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.accessory.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // Delete button — spinner while deleting
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: context.colors.accent,
                                strokeWidth: 2,
                              )
                            : GestureDetector(
                                onTap: onRemove,
                                child: Icon(
                                  Icons.delete_outline,
                                  color: context.colors.error,
                                  size: 22,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.accessory.price.toStringAsFixed(2)} ${'currency'.tr}',
                    style: TextStyle(
                      color: context.colors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: isLoading ? null : onDecrease,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: context.colors.accent,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                '${item.quantity}',
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: isLoading ? null : onIncrease,
                      ),
                      const Spacer(),
                      Text(
                        '${'item_total'.tr}: ${item.totalPrice.toStringAsFixed(2)} ${'currency'.tr}',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: context.colors.surfaceVariant,
      child: Icon(
        Icons.image_outlined,
        color: context.colors.textDisabled,
        size: 28,
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: disabled
              ? context.colors.textDisabled.withValues(alpha: 0.15)
              : context.colors.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: disabled
                ? context.colors.textDisabled.withValues(alpha: 0.3)
                : context.colors.accent.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          icon,
          color: disabled ? context.colors.textDisabled : context.colors.accent,
          size: 16,
        ),
      ),
    );
  }
}
