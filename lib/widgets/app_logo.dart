import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({Key? key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Scale the canvas based on the 40x40 viewBox from the SVG
    final double scaleX = size.width / 40;
    final double scaleY = size.height / 40;
    canvas.scale(scaleX, scaleY);

    // 1. Background Rect
    final Paint bgPaint = Paint()
      ..color = Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, 40, 40), Radius.circular(10)),
        bgPaint);

    // Gradient Definition
    final ui.Gradient travelGradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(40, 40),
      [Color(0xFF22D3EE), Color(0xFFF59E0B)],
      [0.0, 1.0],
    );

    // 2. Location Pin Shape
    final Paint pinStroke = Paint()
      ..shader = travelGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;
    
    final Path pinPath = Path()
      ..moveTo(20, 32)
      ..cubicTo(20, 32, 12, 24, 12, 18)
      ..cubicTo(12, 13.5817, 15.5817, 10, 20, 10)
      ..cubicTo(24.4183, 10, 28, 13.5817, 28, 18)
      ..cubicTo(28, 24, 20, 32, 20, 32)
      ..close();
    
    canvas.drawPath(pinPath, pinStroke);

    // 3. Minimal Airplane Shape
    final Paint planeFill = Paint()
      ..shader = travelGradient
      ..style = PaintingStyle.fill;
    
    final Path planePath = Path()
      ..moveTo(17, 17)
      ..lineTo(21, 15)
      ..lineTo(25, 17)
      ..lineTo(23, 19)
      ..lineTo(21, 23)
      ..lineTo(19, 19)
      ..lineTo(17, 17)
      ..close();
      
    canvas.drawPath(planePath, planeFill);

    // 4. Decorative Flight Trail
    final Paint trailStroke = Paint()
      ..color = Color(0xFF22D3EE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
      
    // Fake the dash array with two small line segments along the quadratic bezier path
    canvas.drawLine(Offset(14, 22), Offset(15, 21.2), trailStroke);
    canvas.drawLine(Offset(17.2, 19.5), Offset(18.5, 18.5), trailStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
