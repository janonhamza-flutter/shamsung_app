import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/map_picker_page.dart';
import '../controllers/store_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final StoreController controller = Get.find<StoreController>();

  String _selectedMethod = 'cash_on_delivery';
  double? _latitude;
  double? _longitude;
  String? _locationName;

  Future<void> _openMapPicker() async {
    final result = await Get.to<MapPickerResult>(() => const MapPickerPage());
    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _locationName = result.locationName;
      });
    }
  }

  Future<void> _onConfirm() async {
    if (_latitude == null || _longitude == null) return;
    final success = await controller.checkout(
      paymentMethod: _selectedMethod,
      latitude: _latitude!,
      longitude: _longitude!,
    );
    if (success && mounted) _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final orders = controller.lastCheckoutResult.value?.orders ?? [];
    final orderNumber = orders.isNotEmpty ? orders.first.orderNumber : '';
    final shopName = orders.isNotEmpty ? (orders.first.shop?.name ?? '') : '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.green,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'order_confirmed'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (orderNumber.isNotEmpty)
              Text(
                '${'order_number'.tr}: $orderNumber',
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (shopName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                '${'center_name'.tr}: $shopName',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              _selectedMethod == 'cash_on_delivery'
                  ? 'checkout_confirm_cod'.tr
                  : 'checkout_confirm_pas'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 12),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('ok'.tr, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: Text(
          'checkout'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Summary ──────────────────────────────────────
            _SectionTitle(title: 'order_summary'.tr),
            const SizedBox(height: 12),
            _OrderSummaryCard(controller: controller),
            const SizedBox(height: 28),

            // ── Location ───────────────────────────────────────────
            _SectionTitle(title: 'delivery_location'.tr),
            const SizedBox(height: 12),
            _LocationCard(
              locationName: _locationName,
              isSelected: _latitude != null,
              onTap: _openMapPicker,
            ),
            const SizedBox(height: 28),

            // ── Payment Method ─────────────────────────────────────
            _SectionTitle(title: 'payment_method'.tr),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              method: 'cash_on_delivery',
              title: 'payment_cash_on_delivery'.tr,
              subtitle: 'payment_cod_sub'.tr,
              icon: Icons.money_rounded,
              selected: _selectedMethod == 'cash_on_delivery',
              onTap: () => setState(() => _selectedMethod = 'cash_on_delivery'),
            ),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              method: 'pay_after_service',
              title: 'payment_pay_after_service'.tr,
              subtitle: 'payment_pas_sub'.tr,
              icon: Icons.credit_card_rounded,
              selected: _selectedMethod == 'pay_after_service',
              onTap: () =>
                  setState(() => _selectedMethod = 'pay_after_service'),
            ),
            const SizedBox(height: 36),

            // ── Confirm Button ─────────────────────────────────────
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_latitude == null || controller.isCheckingOut.value)
                      ? null
                      : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    disabledBackgroundColor: AppColors.green.withValues(
                      alpha: 0.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isCheckingOut.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _latitude == null
                              ? 'select_delivery_location_first'.tr
                              : 'place_order'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String? locationName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationCard({
    required this.locationName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.4)
                : Colors.white24,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.green.withValues(alpha: 0.15)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected
                    ? Icons.location_on_rounded
                    : Icons.add_location_alt_rounded,
                color: isSelected ? AppColors.green : Colors.white54,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSelected
                        ? 'location_selected'.tr
                        : 'set_delivery_location'.tr,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isSelected &&
                      locationName != null &&
                      locationName!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      locationName!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.edit_location_alt_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: isSelected ? AppColors.green : Colors.white38,
              size: isSelected ? 22 : 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final StoreController controller;
  const _OrderSummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...controller.cartItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.accessory.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.quantity} × ${item.accessory.price.toStringAsFixed(2)} ${'currency'.tr}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 24),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.cartTotal.toStringAsFixed(2)} ${'currency'.tr}',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String method;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green.withValues(alpha: 0.15)
              : AppColors.blue,
          border: Border.all(
            color: selected ? AppColors.green : Colors.white12,
            width: selected ? 1.8 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.green.withValues(alpha: 0.2)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.green : Colors.white54,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 15,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.green : Colors.white30,
                  width: 2,
                ),
                color: selected ? AppColors.green : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
