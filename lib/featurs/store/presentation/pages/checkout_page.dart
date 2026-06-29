import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../controllers/store_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final StoreController controller = Get.find<StoreController>();

  // Selected payment method: "cash_on_delivery" | "online"
  String _selectedMethod = 'cash_on_delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: const Text(
          'تأكيد الطلب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Summary ───────────────────────────────────────────
            const _SectionTitle(title: 'ملخص الطلب'),
            const SizedBox(height: 12),
            _OrderSummaryCard(controller: controller),
            const SizedBox(height: 28),

            // ── Payment Method ──────────────────────────────────────────
            const _SectionTitle(title: 'طريقة الدفع'),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              method: 'cash_on_delivery',
              title: 'الدفع عند الاستلام',
              subtitle: 'ادفع نقداً عند استلام طلبك',
              icon: Icons.money_rounded,
              selected: _selectedMethod == 'cash_on_delivery',
              onTap: () => setState(() => _selectedMethod = 'cash_on_delivery'),
            ),
            const SizedBox(height: 12),
            _PaymentMethodCard(
              method: 'online',
              title: 'الدفع الإلكتروني',
              subtitle: 'ادفع الآن بطريقة آمنة عبر الإنترنت',
              icon: Icons.credit_card_rounded,
              selected: _selectedMethod == 'online',
              onTap: () => setState(() => _selectedMethod = 'online'),
            ),
            const SizedBox(height: 36),

            // ── Confirm Button ──────────────────────────────────────────
            // Obx wraps only the button so it reacts to isCheckingOut
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isCheckingOut.value ? null : _onConfirm,
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
                      : const Text(
                          'تأكيد الطلب',
                          style: TextStyle(
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

  Future<void> _onConfirm() async {
    final success = await controller.checkout(paymentMethod: _selectedMethod);
    if (success && mounted) {
      _showSuccessDialog();
    }
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
            const Text(
              'تم تأكيد طلبك!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (orderNumber.isNotEmpty)
              Text(
                'رقم الطلب: $orderNumber',
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (shopName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
               "اسم المركز:$shopName",
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              _selectedMethod == 'cash_on_delivery'
                  ? 'سيتم التواصل معك لتأكيد موعد التسليم.\nالدفع عند الاستلام.'
                  : 'تمت معالجة دفعتك الإلكترونية بنجاح.',
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
                Get.back(); // close dialog
                Get.back(); // back to cart
                Get.back(); // back to store
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('حسناً', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

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

// ── Order Summary Card ────────────────────────────────────────────────────────

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
          // Items list — static snapshot, no reactive needed here
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
                    '${item.quantity} × ${item.accessory.price.toStringAsFixed(2)} SP',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 24),
          // Total — reactive
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.cartTotal.toStringAsFixed(2)} SP',
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

// ── Payment Method Card ───────────────────────────────────────────────────────

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
            // Icon box
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
            // Labels
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
            // Radio circle
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
