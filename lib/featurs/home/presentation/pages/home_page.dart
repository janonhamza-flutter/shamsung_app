import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/route/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
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
        backgroundColor: AppColors.darkBlue,
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
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }
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
      gradientStart: const Color(0xFF0A2F6B),
      gradientEnd: const Color(0xFF0D3D8A),
    ),
    _PromoSlide(
      icon: Icons.flash_on_rounded,
      tagKey: 'promo_tag_fast',
      headlineKey: 'promo_headline_fast',
      bodyKey: 'promo_body_fast',
      accent: const Color(0xFFFFC107),
      gradientStart: const Color(0xFF1A237E),
      gradientEnd: const Color(0xFF283593),
    ),
    _PromoSlide(
      icon: Icons.support_agent_rounded,
      tagKey: 'promo_tag_ai',
      headlineKey: 'promo_headline_ai',
      bodyKey: 'promo_body_ai',
      accent: const Color(0xFFCE93D8),
      gradientStart: const Color(0xFF4A148C),
      gradientEnd: const Color(0xFF6A1B9A),
    ),
    _PromoSlide(
      icon: Icons.location_on_rounded,
      tagKey: 'promo_tag_near',
      headlineKey: 'promo_headline_near',
      bodyKey: 'promo_body_near',
      accent: const Color(0xFF4FC3F7),
      gradientStart: const Color(0xFF01579B),
      gradientEnd: const Color(0xFF0277BD),
    ),
    _PromoSlide(
      icon: Icons.storefront_rounded,
      tagKey: 'promo_tag_shop',
      headlineKey: 'promo_headline_shop',
      bodyKey: 'promo_body_shop',
      accent: const Color(0xFFFFB74D),
      gradientStart: const Color(0xFF4E342E),
      gradientEnd: const Color(0xFF6D4C41),
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? slides[_currentPage].accent : Colors.white24,
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
  final Color accent;
  final Color gradientStart;
  final Color gradientEnd;

  const _PromoSlide({
    required this.icon,
    required this.tagKey,
    required this.headlineKey,
    required this.bodyKey,
    required this.accent,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

class _PromoSlideCard extends StatelessWidget {
  final _PromoSlide slide;
  const _PromoSlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [slide.gradientStart, slide.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
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
                    color: slide.accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: slide.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    slide.tagKey.tr,
                    style: TextStyle(
                      color: slide.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.headlineKey.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  slide.bodyKey.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
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
              color: slide.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: slide.accent.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(slide.icon, color: slide.accent, size: 32),
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
                  gradient: const LinearGradient(
                    colors: [AppColors.green, Color(0xFF0FA84A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                    colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A2F6B), Color(0xFF0D3D8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleKey.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleKey.tr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
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
