import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';

/// Builds the app's [ThemeData] for both brightnesses from a single
/// [AppPalette], so component themes (AppBar, buttons, inputs, cards…)
/// always stay in sync with the semantic color system.
class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(AppPalette.light);
  static final ThemeData dark = _build(AppPalette.dark);

  static ThemeData _build(AppPalette palette) {
    final colorScheme = palette.isDark
        ? ColorScheme.dark(
            brightness: Brightness.dark,
            primary: palette.primary,
            onPrimary: palette.textOnPrimary,
            secondary: palette.accent,
            onSecondary: palette.textOnPrimary,
            surface: palette.surface,
            onSurface: palette.textPrimary,
            error: palette.error,
            onError: palette.textOnPrimary,
            outline: palette.border,
          )
        : ColorScheme.light(
            brightness: Brightness.light,
            primary: palette.primary,
            onPrimary: palette.textOnPrimary,
            secondary: palette.accent,
            onSecondary: palette.textOnPrimary,
            surface: palette.surface,
            onSurface: palette.textPrimary,
            error: palette.error,
            onError: palette.textOnPrimary,
            outline: palette.border,
          );

    final baseTextTheme = palette.isDark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;

    final textTheme = baseTextTheme
        .apply(bodyColor: palette.textPrimary, displayColor: palette.textPrimary)
        .copyWith(
          bodySmall: baseTextTheme.bodySmall?.copyWith(
            color: palette.textSecondary,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      primaryColor: palette.primary,
      dividerColor: palette.divider,
      splashColor: palette.accent.withValues(alpha: 0.12),
      highlightColor: palette.accent.withValues(alpha: 0.08),
      shadowColor: palette.shadow,
      textTheme: textTheme,
      extensions: [palette],

      appBarTheme: AppBarTheme(
        backgroundColor: palette.isDark ? palette.background : palette.surface,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: palette.isDark ? 0 : 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.textPrimary),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: palette.isDark
            ? _systemOverlayStyleLight
            : _systemOverlayStyleDark,
      ),

      iconTheme: IconThemeData(color: palette.textPrimary),

      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: palette.isDark ? 0 : 2,
        shadowColor: palette.shadow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: palette.isDark
              ? BorderSide.none
              : BorderSide(color: palette.border),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.textOnPrimary,
          disabledBackgroundColor: palette.surfaceVariant,
          disabledForegroundColor: palette.textDisabled,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.border),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.textOnPrimary,
        elevation: palette.isDark ? 2 : 4,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceVariant,
        hintStyle: TextStyle(color: palette.textDisabled),
        labelStyle: TextStyle(color: palette.textSecondary),
        prefixIconColor: palette.textSecondary,
        suffixIconColor: palette.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.error, width: 1.5),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: palette.isDark ? 4 : 8,
        shadowColor: palette.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: palette.textSecondary,
          fontSize: 14,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: palette.isDark ? 4 : 8,
        modalBarrierColor: palette.overlay,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.isDark
            ? palette.elevatedSurface
            : palette.textPrimary,
        contentTextStyle: TextStyle(color: palette.textOnPrimary),
        actionTextColor: palette.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: TextStyle(color: palette.textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: palette.accent,
        unselectedItemColor: palette.textSecondary,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.accent
              : Colors.transparent,
        ),
        side: BorderSide(color: palette.border, width: 1.5),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.accent
              : palette.textDisabled,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.accent
              : palette.surfaceVariant,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : palette.border,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.accent,
        circularTrackColor: palette.surfaceVariant,
        linearTrackColor: palette.surfaceVariant,
      ),
    );
  }
}

const _systemOverlayStyleLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const _systemOverlayStyleDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
