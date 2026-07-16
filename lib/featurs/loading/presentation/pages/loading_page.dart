import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../controller/loading_controller.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});

  final LoadingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, _) {
          return Stack(
            children: [
              // ── 1. Radial gradient background ────────────────────
              _BackgroundGradient(glowValue: controller.glowAnimation.value),

              // ── 2. Floating particles ─────────────────────────────
              _ParticlesLayer(
                progress: controller.animationController.value,
                opacity: controller.particlesFade.value,
                size: size,
              ),

              // ── 3. Decorative orbit rings ─────────────────────────
              _OrbitRings(
                progress: controller.animationController.value,
                size: size,
              ),

              // ── 4. Main content (centered) ────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -- Logo with float + glow ----------------------
                    _AnimatedLogo(
                      floatValue: controller.logoFloatAnimation.value,
                      glowValue: controller.glowAnimation.value,
                    ),

                    const SizedBox(height: 32),

                    // -- App name -----------------------------------
                    SlideTransition(
                      position: controller.textSlide,
                      child: FadeTransition(
                        opacity: controller.textFade,
                        child: _AppTitle(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // -- Tagline ------------------------------------
                    FadeTransition(
                      opacity: controller.taglineFade,
                      child: _Tagline(),
                    ),

                    const SizedBox(height: 56),

                    // -- Progress bar -------------------------------
                    _ProgressBar(
                      progress: controller.progressAnimation.value,
                      width: size.width * 0.62,
                    ),

                    const SizedBox(height: 20),

                    // -- Loading label ------------------------------
                    FadeTransition(
                      opacity: controller.taglineFade,
                      child: _LoadingLabel(
                        progress: controller.progressAnimation.value,
                      ),
                    ),
                  ],
                ),
              ),

              // ── 5. Bottom branding ────────────────────────────────
              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: controller.taglineFade,
                  child: const _BottomBrand(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Background gradient that pulses
// ─────────────────────────────────────────────────────────────────────────────
class _BackgroundGradient extends StatelessWidget {
  final double glowValue;
  const _BackgroundGradient({required this.glowValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            Color.lerp(
              const Color(0xFF0A3080),
              const Color(0xFF1756C8),
              glowValue * 0.6,
            )!,
            AppColors.darkBlue,
            const Color(0xFF020D1F),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating light particles
// ─────────────────────────────────────────────────────────────────────────────
class _ParticlesLayer extends StatelessWidget {
  final double progress;
  final double opacity;
  final Size size;

  const _ParticlesLayer({
    required this.progress,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: size,
        painter: _ParticlesPainter(progress: progress),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double progress;
  static final _rng = math.Random(42);

  static final List<_Particle> _particles = List.generate(28, (i) {
    return _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      radius: _rng.nextDouble() * 2.4 + 0.8,
      speed: _rng.nextDouble() * 0.18 + 0.06,
      phase: _rng.nextDouble() * math.pi * 2,
    );
  });

  _ParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final dy = (p.y - progress * p.speed) % 1.0;
      final dx = p.x + math.sin(progress * math.pi * 2 + p.phase) * 0.018;
      final opacity = (math.sin(progress * math.pi * 2 + p.phase) * 0.3 + 0.5)
          .clamp(0.2, 0.8);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);

      canvas.drawCircle(
        Offset(dx * size.width, dy * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, radius, speed, phase;
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative rotating orbit rings
// ─────────────────────────────────────────────────────────────────────────────
class _OrbitRings extends StatelessWidget {
  final double progress;
  final Size size;
  const _OrbitRings({required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _OrbitPainter(progress: progress),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;
  _OrbitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.38);

    _drawRing(canvas, center, 118, progress, clockwise: true, opacity: 0.12);
    _drawRing(canvas, center, 148, progress, clockwise: false, opacity: 0.08);
    _drawRing(canvas, center, 180, progress, clockwise: true, opacity: 0.05);
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double progress, {
    required bool clockwise,
    required double opacity,
  }) {
    final angle = progress * math.pi * 2 * (clockwise ? 1 : -1);

    // Draw dashed ring
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, paint);

    // Draw glowing dot on the ring
    final dotX = center.dx + math.cos(angle) * radius;
    final dotY = center.dy + math.sin(angle) * radius;

    final dotPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: opacity * 4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated logo with float + glow
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedLogo extends StatelessWidget {
  final double floatValue;
  final double glowValue;
  const _AnimatedLogo({required this.floatValue, required this.glowValue});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -floatValue * math.sin(floatValue * 0.3)),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF1E88E5,
              ).withValues(alpha: glowValue * 0.55),
              blurRadius: 40,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: const Color(0xFF42A5F5).withValues(alpha: glowValue * 0.3),
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
        child: ClipOval(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF0A2F6B)],
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App title
// ─────────────────────────────────────────────────────────────────────────────
class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF90CAF9), Colors.white, Color(0xFF64B5F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        'SHAMSOUNG',
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tagline
// ─────────────────────────────────────────────────────────────────────────────
class _Tagline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Your Smart Companion',
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF90CAF9),
        letterSpacing: 2.5,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glowing progress bar
// ─────────────────────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final double progress;
  final double width;
  const _ProgressBar({required this.progress, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Track
              Container(
                height: 4,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Fill with glow
              AnimatedContainer(
                duration: Duration.zero,
                height: 4,
                width: width * progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E88E5),
                      Color(0xFF42A5F5),
                      Color(0xFF80D8FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.8),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              // Leading glow dot
              if (progress > 0.02)
                Positioned(
                  left: (width * progress) - 6,
                  top: -4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF42A5F5).withValues(alpha: 0.9),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading percentage label
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingLabel extends StatelessWidget {
  final double progress;
  const _LoadingLabel({required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulsingDot(),
        const SizedBox(width: 8),
        Text(
          'Loading... $pct%',
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontSize: 13,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF42A5F5).withValues(alpha: _anim.value),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF42A5F5,
              ).withValues(alpha: _anim.value * 0.8),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom brand text
// ─────────────────────────────────────────────────────────────────────────────
class _BottomBrand extends StatelessWidget {
  const _BottomBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => _dot(i * 200)),
        ),
        const SizedBox(height: 10),
        Text(
          'v1.0.0',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.25),
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _dot(int delayMs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: _BouncingDot(delayMs: delayMs),
    );
  }
}

class _BouncingDot extends StatefulWidget {
  final int delayMs;
  const _BouncingDot({required this.delayMs});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF42A5F5).withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
