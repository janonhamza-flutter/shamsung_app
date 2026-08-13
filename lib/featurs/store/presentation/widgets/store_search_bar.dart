import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_palette.dart';

class StoreSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const StoreSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'search_product'.tr,
          hintStyle: TextStyle(
            color: context.colors.textDisabled,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.colors.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}
