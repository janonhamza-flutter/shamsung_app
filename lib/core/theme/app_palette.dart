import 'package:flutter/material.dart';

/// Semantic, theme-aware color palette for the app.
///
/// Access via `context.colors` (see [AppPaletteX]) instead of reaching for
/// [Colors.white] / [Colors.black] / raw hex literals in widgets, so every
/// screen automatically adapts between [AppPalette.dark] (the app's
/// original navy identity) and [AppPalette.light] (new, purpose-built).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.elevatedSurface,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.border,
    required this.divider,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.shadow,
    required this.overlay,
    required this.brightness,
  });

  /// Page / scaffold background — the base of the surface hierarchy.
  final Color background;

  /// Cards, dialogs, sheets, app bar — one step above [background].
  final Color surface;

  /// Subtle containers nested inside a [surface] (inputs, chips, list rows).
  final Color surfaceVariant;

  /// Surfaces that sit above other surfaces (nested cards, popovers, FAB).
  final Color elevatedSurface;

  /// Brand primary — navy blue. Intentionally identical in [light] and
  /// [dark] so hero banners/headers keep the app's brand chrome regardless
  /// of theme (only the content below adapts).
  final Color primary;

  /// Deepest brand shade — gradients, headers. Also brand-invariant.
  final Color primaryDark;

  /// Lightest brand shade — hover/tint backgrounds, secondary chips.
  final Color primaryLight;

  /// Brand accent / call-to-action — green.
  final Color accent;

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  /// Text/icons placed on top of [primary]/[accent] solid fills.
  final Color textOnPrimary;

  final Color border;
  final Color divider;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  /// Shadow tint used for card/nav elevation.
  final Color shadow;

  /// Scrim behind dialogs/sheets.
  final Color overlay;

  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;

  static const AppPalette dark = AppPalette(
    background: Color(0xFF041E42),
    surface: Color(0xFF0A2F6B),
    surfaceVariant: Color(0xFF123B74),
    elevatedSurface: Color(0xFF15448A),
    primary: Color(0xFF0A2F6B),
    primaryDark: Color(0xFF041E42),
    primaryLight: Color(0xFF5B87C9),
    accent: Color(0xFF16C75B),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFB7C4D9),
    textDisabled: Color(0xFF7C8AA3),
    textOnPrimary: Colors.white,
    border: Color(0x1FFFFFFF),
    divider: Color(0x14FFFFFF),
    success: Color(0xFF16C75B),
    warning: Color(0xFFFFB74D),
    error: Color(0xFFEF5350),
    info: Color(0xFF4FC3F7),
    shadow: Color(0x59000000),
    overlay: Color(0x99000000),
    brightness: Brightness.dark,
  );

  /// Not an inversion of [dark] — a purpose-built light palette that keeps
  /// the navy/green brand identity while introducing a proper surface
  /// hierarchy (background → surface → elevatedSurface) and text contrast
  /// tuned for light backgrounds.
  static const AppPalette light = AppPalette(
    background: Color(0xFFF3F6FB),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEAEFF6),
    elevatedSurface: Color(0xFFFFFFFF),
    primary: Color(0xFF0A2F6B),
    primaryDark: Color(0xFF041E42),
    primaryLight: Color(0xFFE3EAF5),
    accent: Color(0xFF16A34A),
    textPrimary: Color(0xFF101B2D),
    textSecondary: Color(0xFF57647A),
    textDisabled: Color(0xFFA1ABBC),
    textOnPrimary: Colors.white,
    border: Color(0xFFDFE5EE),
    divider: Color(0xFFE8ECF3),
    success: Color(0xFF16A34A),
    warning: Color(0xFFED8A19),
    error: Color(0xFFDC2626),
    info: Color(0xFF0284C7),
    shadow: Color(0x1F0A2F6B),
    overlay: Color(0x66101B2D),
    brightness: Brightness.light,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? elevatedSurface,
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? border,
    Color? divider,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? shadow,
    Color? overlay,
    Brightness? brightness,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      shadow: shadow ?? this.shadow,
      overlay: overlay ?? this.overlay,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
    );
  }
}

/// Shortcut for `Theme.of(context).extension<AppPalette>()!`.
extension AppPaletteX on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;
}
