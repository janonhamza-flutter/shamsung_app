import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/exit_scope.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ExitScope(
      child: Scaffold(
        backgroundColor: context.colors.background,
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                const HomeHeader(),
                const SizedBox(height: 20),

                // ── Promo Carousel ──────────────────────────────────
                const _PromoCarousel(),
                const SizedBox(height: 28),

                // ── Quick Actions ───────────────────────────────────
                _SectionLabel(label: 'quick_actions'.tr),
                const SizedBox(height: 14),
                Expanded(child: _QuickActionsGrid()),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: context.colors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared "premium glow" shadow — a soft, color-tinted shadow in the card's own
// hue (for lift/integration against the page background) layered under a
// neutral ambient shadow (for grounding). Benefits both themes, but matters
// most in Light Mode where a plain neutral shadow reads as flat/weak against
// the pale background.
// ─────────────────────────────────────────────────────────────────────────────

List<BoxShadow> _glowShadow(BuildContext context, Color glowColor) {
  return [
    BoxShadow(
      color: glowColor.withValues(alpha: context.colors.isDark ? 0.28 : 0.22),
      blurRadius: 22,
      offset: const Offset(0, 10),
      spreadRadius: -6,
    ),
    BoxShadow(
      color: context.colors.shadow,
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Promo Carousel — auto-scrolling with dot indicator
// ─────────────────────────────────────────────────────────────────────────────

class _PromoCarousel extends StatefulWidget {
  const _PromoCarousel();

  @override
  State<_PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<_PromoCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  List<_PromoSlide> get _slides => [
    _PromoSlide(
      icon: Icons.verified_user_rounded,
      tagKey: 'promo_tag_official',
      headlineKey: 'promo_headline_official',
      bodyKey: 'promo_body_official',
      accent: const Color(0xFF16C75B),
      lightAccent: const Color(0xFF0E8A45),
      gradientStart: const Color(0xFF0A2F6B),
      gradientEnd: const Color(0xFF0D3D8A),
    ),
    _PromoSlide(
      icon: Icons.flash_on_rounded,
      tagKey: 'promo_tag_fast',
      headlineKey: 'promo_headline_fast',
      bodyKey: 'promo_body_fast',
      accent: const Color(0xFFFFC107),
      lightAccent: const Color(0xFFB4650A),
      gradientStart: const Color(0xFF1A237E),
      gradientEnd: const Color(0xFF283593),
    ),
    _PromoSlide(
      icon: Icons.support_agent_rounded,
      tagKey: 'promo_tag_ai',
      headlineKey: 'promo_headline_ai',
      bodyKey: 'promo_body_ai',
      accent: const Color(0xFFC7B9FF),
      lightAccent: const Color(0xFF4338CA),
      gradientStart: const Color(0xFF322E81),
      gradientEnd: const Color(0xFF4F46E5),
    ),
    _PromoSlide(
      icon: Icons.location_on_rounded,
      tagKey: 'promo_tag_near',
      headlineKey: 'promo_headline_near',
      bodyKey: 'promo_body_near',
      accent: const Color(0xFF4FC3F7),
      lightAccent: const Color(0xFF0277BD),
      gradientStart: const Color(0xFF01579B),
      gradientEnd: const Color(0xFF0277BD),
    ),
    _PromoSlide(
      icon: Icons.storefront_rounded,
      tagKey: 'promo_tag_shop',
      headlineKey: 'promo_headline_shop',
      bodyKey: 'promo_body_shop',
      accent: const Color(0xFFFFB74D),
      lightAccent: const Color(0xFF0B6B4F),
      gradientStart: const Color(0xFF0B4F3A),
      gradientEnd: const Color(0xFF10715A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _PromoSlideCard(slide: slides[i]),
          ),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (i) {
            final active = i == _currentPage;
            final current = slides[_currentPage];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active
                    ? (context.colors.isDark
                          ? current.accent
                          : current.lightAccent)
                    : context.colors.textDisabled,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PromoSlide {
  final IconData icon;
  final String tagKey;
  final String headlineKey;
  final String bodyKey;

  /// Accent used in Dark Mode, where the card itself is a saturated dark
  /// gradient — needs to be light/bright to read against it.
  final Color accent;

  /// Accent used in Light Mode, where the card is a near-white tinted
  /// surface — needs to be deep/saturated enough to read against white.
  final Color lightAccent;

  /// Full gradient fill, Dark Mode only.
  final Color gradientStart;
  final Color gradientEnd;

  const _PromoSlide({
    required this.icon,
    required this.tagKey,
    required this.headlineKey,
    required this.bodyKey,
    required this.accent,
    required this.lightAccent,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class _PromoSlideCard extends StatelessWidget {
  final _PromoSlide slide;
  const _PromoSlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    final isDark = context.colors.isDark;
    // Dark Mode: the original full saturated gradient card, unchanged.
    // Light Mode: a near-white surface carrying the slide's brand color via
    // its border/tag/icon instead of a full dark gradient fill — a solid
    // dark card here would look like Dark Mode content pasted onto a light
    // page rather than a native part of the Light Mode UI.
    final accent = isDark ? slide.accent : slide.lightAccent;
    final surface = context.colors.surface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [slide.gradientStart, slide.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Color.lerp(surface, slide.lightAccent, 0.05)!,
                  Color.lerp(surface, slide.lightAccent, 0.13)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(22),
        border: isDark
            ? null
            : Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: _glowShadow(context, isDark ? slide.gradientEnd : accent),
      ),
      child: Row(
        children: [
          // Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tag pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    slide.tagKey.tr,
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.headlineKey.tr,
                  style: TextStyle(
                    color: isDark
                        ? context.colors.textOnPrimary
                        : context.colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  slide.bodyKey.tr,
                  style: TextStyle(
                    color: isDark
                        ? context.colors.textOnPrimary.withValues(alpha: 0.65)
                        : context.colors.textSecondary,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Icon side
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.15 : 0.13),
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(slide.icon, color: accent, size: 32),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions Grid
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: _ActionCard(
                  icon: Icons.build_rounded,
                  titleKey: 'action_request_repair',
                  subtitleKey: 'action_request_repair_sub',
                  gradient: LinearGradient(
                    colors: [context.colors.accent, const Color(0xFF0FA84A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: context.colors.accent,
                  onTap: () => Get.toNamed(AppRoutes.createRequest),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _ActionCard(
                  icon: Icons.location_on_rounded,
                  titleKey: 'action_find_shop',
                  subtitleKey: 'action_find_shop_sub',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: const Color(0xFF1565C0),
                  onTap: () => Get.toNamed(AppRoutes.nearestShop),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _ActionCard(
                  icon: Icons.chat_bubble_rounded,
                  titleKey: 'action_ask_ai',
                  subtitleKey: 'action_ask_ai_sub',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF322E81), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: const Color(0xFF4338CA),
                  onTap: () => Get.toNamed(AppRoutes.consultations),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _ActionCard(
                  icon: Icons.storefront_rounded,
                  titleKey: 'action_browse_store',
                  subtitleKey: 'action_browse_store_sub',
                  gradient: LinearGradient(
                    colors: [
                      context.colors.primary,
                      context.colors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: context.colors.primary,
                  onTap: () => Get.toNamed(AppRoutes.store),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String subtitleKey;

  /// Full gradient fill, Dark Mode only.
  final Gradient gradient;

  /// The card's identity color — used as the Light Mode surface tint /
  /// icon / border / shadow tint, and as the Dark Mode shadow tint.
  final Color glowColor;

  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.gradient,
    required this.glowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.colors.isDark;
    final surface = context.colors.surface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // Dark Mode: the original full saturated gradient tile, unchanged.
          // Light Mode: a near-white tinted surface — a solid saturated
          // gradient here would look identical to Dark Mode content sitting
          // on top of a light page, not a native part of it.
          gradient: isDark
              ? gradient
              : LinearGradient(
                  colors: [
                    Color.lerp(surface, glowColor, 0.05)!,
                    Color.lerp(surface, glowColor, 0.13)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? null
              : Border.all(color: glowColor.withValues(alpha: 0.22)),
          boxShadow: _glowShadow(context, glowColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? context.colors.textOnPrimary.withValues(alpha: 0.15)
                    : glowColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDark ? context.colors.textOnPrimary : glowColor,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.tr,
                  style: TextStyle(
                    color: isDark
                        ? context.colors.textOnPrimary
                        : context.colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleKey.tr,
                  style: TextStyle(
                    color: isDark
                        ? context.colors.textOnPrimary.withValues(alpha: 0.65)
                        : context.colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
