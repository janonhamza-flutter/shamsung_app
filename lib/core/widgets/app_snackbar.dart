import 'package:get/get.dart';

import '../theme/app_palette.dart';

class AppSnackbar {
  static void success(String message) {
    final colors = _paletteOrFallback();
    Get.snackbar(
      "Success",
      message,
      backgroundColor: colors.success,
      colorText: colors.textOnPrimary,
    );
  }

  static void error(String message) {
    final colors = _paletteOrFallback();
    Get.snackbar(
      "Error",
      message,
      backgroundColor: colors.error,
      colorText: colors.textOnPrimary,
    );
  }

  static AppPalette _paletteOrFallback() {
    final context = Get.context;
    if (context == null) return AppPalette.dark;
    return context.colors;
  }
}
