import 'package:flutter/material.dart';
import 'dart:math';

class StepProgressPainter extends CustomPainter {
  final int stepCount;
  final int stepGoal;

  StepProgressPainter(this.stepCount, this.stepGoal);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw background semicircle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start from the left
      pi, // Sweep angle for semicircle
      false,
      paint,
    );

    // Calculate progress arc length
    final double progress = (stepCount / stepGoal).clamp(0.0, 1.0) * pi;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Start from the left
      progress, // Sweep angle based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
