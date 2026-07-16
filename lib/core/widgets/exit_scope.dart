import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

/// Wraps any root (bottom-nav) page with double-back-to-exit behaviour.
///
/// First back press → shows a snackbar for [duration].
/// Second back press within [duration] → exits the app.
class ExitScope extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ExitScope({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<ExitScope> createState() => _ExitScopeState();
}

class _ExitScopeState extends State<ExitScope> {
  DateTime? _lastBackPressed;

  Future<bool> _handlePop() async {
    final now = DateTime.now();

    final isFirstPress =
        _lastBackPressed == null ||
        now.difference(_lastBackPressed!) > widget.duration;

    if (isFirstPress) {
      _lastBackPressed = now;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'press_back_exit'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.blue,
            duration: widget.duration,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
        );
      return false; // لا تخرج بعد
    }

    // الضغطة الثانية — أخرج
    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handlePop();
      },
      child: widget.child,
    );
  }
}
