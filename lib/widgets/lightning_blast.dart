import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LightningBlast extends StatefulWidget {
  final VoidCallback onComplete;

  const LightningBlast({super.key, required this.onComplete});

  @override
  State<LightningBlast> createState() => _LightningBlastState();
}

class _LightningBlastState extends State<LightningBlast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward().then((_) => widget.onComplete());
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
      builder: (context, child) {
        return CustomPaint(
          painter: LightningPainter(progress: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class LightningPainter extends CustomPainter {
  final double progress;
  final Random _random = Random();

  LightningPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF9C27B0).withOpacity(1.0 - progress) // Purple
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFFE040FB).withOpacity(1.0 - progress) // Lighter Purple Glow
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Draw multiple lightning bolts
    for (int i = 0; i < 8; i++) {
      _drawBolt(canvas, center, size, paint, glowPaint, i * (pi / 4));
    }

    // Draw central blast
    final blastRadius = progress * size.width * 0.8;
    final blastPaint = Paint()
      ..color = const Color(0xFF9C27B0).withOpacity((1.0 - progress) * 0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(center, blastRadius, blastPaint);
  }

  void _drawBolt(Canvas canvas, Offset start, Size size, Paint paint, Paint glowPaint, double angle) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    double currentX = start.dx;
    double currentY = start.dy;
    double length = size.width * 0.6 * progress; // Grow outward
    
    int segments = 10;
    double segmentLength = length / segments;

    for (int i = 0; i < segments; i++) {
      double offset = (_random.nextDouble() - 0.5) * 30; // Random jitter
      
      double nextX = start.dx + cos(angle) * (i + 1) * segmentLength + offset * sin(angle);
      double nextY = start.dy + sin(angle) * (i + 1) * segmentLength + offset * cos(angle);

      path.lineTo(nextX, nextY);
      currentX = nextX;
      currentY = nextY;
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LightningPainter oldDelegate) => oldDelegate.progress != progress;
}
