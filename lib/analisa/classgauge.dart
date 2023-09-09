import 'package:flutter/material.dart';
import 'dart:math';

class Gauge extends StatelessWidget {
  final double value; // Nilai yang akan ditampilkan di Gauge

  Gauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: GaugePainter(value: value),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;

  GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    // Gambar latar belakang Gauge
    final bgPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, bgPaint);

    // Gambar indikator Gauge
    final indicatorPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    final sweepAngle = 2 * pi * (value / 100); // Ubah nilai menjadi sudut
    canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        indicatorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
