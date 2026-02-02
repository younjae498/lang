import 'package:flutter/material.dart';

class SnakePathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final Color color;

  SnakePathPainter({required this.nodePositions, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodePositions.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // In the dashboard, centerX is 300 since the center column width is 600
    const double centerX = 300;

    path.moveTo(centerX + nodePositions[0].dx, nodePositions[0].dy + 40);

    for (int i = 0; i < nodePositions.length - 1; i++) {
        final p1 = nodePositions[i];
        final p2 = nodePositions[i + 1];

        final double midY = (p1.dy + p2.dy) / 2 + 40;
        
        path.quadraticBezierTo(
          centerX + p1.dx,
          midY,
          centerX + (p1.dx + p2.dx) / 2,
          midY,
        );
        path.quadraticBezierTo(
          centerX + p2.dx,
          midY,
          centerX + p2.dx,
          p2.dy + 40,
        );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
