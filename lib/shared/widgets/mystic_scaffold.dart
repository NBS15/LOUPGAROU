import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme.dart';

class MysticScaffold extends StatelessWidget {
  const MysticScaffold({super.key, required this.child, this.appBar});

  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          const _NightBackground(),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class _NightBackground extends StatefulWidget {
  const _NightBackground();

  @override
  State<_NightBackground> createState() => _NightBackgroundState();
}

class _NightBackgroundState extends State<_NightBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final drift = math.sin(_controller.value * math.pi) * 32;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.midnight, AppColors.nightBlue, Color(0xFF160813)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80 + drift,
                left: -90,
                child: _Glow(color: AppColors.crimson.withOpacity(.22), size: 240),
              ),
              Positioned(
                right: -70,
                bottom: 120 - drift,
                child: _Glow(color: AppColors.gold.withOpacity(.16), size: 220),
              ),
              Positioned.fill(
                child: CustomPaint(painter: _StarsPainter(_controller.value)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 54)],
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  _StarsPainter(this.phase);

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(.08 + phase * .05);
    for (var i = 0; i < 44; i++) {
      final x = (i * 73) % size.width;
      final y = (i * 41) % (size.height * .72);
      canvas.drawCircle(Offset(x, y), (i % 3 + 1) * .55, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => oldDelegate.phase != phase;
}
