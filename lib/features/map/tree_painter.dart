import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../ui/theme/brand_colors.dart';

/// 나무 줄기와 가지를 그리는 Painter
class TreePainter extends CustomPainter {
  final List<Offset> nodePositions;
  final int completedCount;
  
  TreePainter({
    required this.nodePositions,
    required this.completedCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 나무 색상 (Solid - Brand Brown)
    const Color trunkColor = Color(0xFF795548); 
    const Color branchColor = Color(0xFF8D6E63);
    
    // 줄기 그리기
    _drawTrunk(canvas, size, trunkColor);
    
    // 가지들 그리기
    _drawBranches(canvas, size, branchColor);
  }

  void _drawTrunk(Canvas canvas, Size size, Color color) {
    final trunkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final trunkStart = size.height;
    final trunkEnd = nodePositions.isNotEmpty 
        ? nodePositions.map((p) => p.dy).reduce(math.min) - 40
        : size.height * 0.2;

    // Solid Tapered Trunk (Toy like)
    final Path path = Path();
    const double bWidth = 36.0;
    const double tWidth = 24.0;
    
    path.moveTo(centerX - bWidth / 2, trunkStart);
    path.lineTo(centerX - tWidth / 2, trunkEnd);
    path.lineTo(centerX + tWidth / 2, trunkEnd);
    path.lineTo(centerX + bWidth / 2, trunkStart);
    path.close();

    canvas.drawPath(path, trunkPaint);
  }

  void _drawBranches(Canvas canvas, Size size, Color color) {
    if (nodePositions.isEmpty) return;

    final branchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    for (int i = 0; i < nodePositions.length; i++) {
        final nodePos = nodePositions[i];
        final branchPath = Path();
        
        // Start from trunk center at node's Y
        branchPath.moveTo(centerX, nodePos.dy + 15);
        
        // Solid Curved Branch
        branchPath.quadraticBezierTo(
            (centerX + nodePos.dx) / 2,
            nodePos.dy,
            nodePos.dx,
            nodePos.dy,
        );

        // Color logic (Solid vivid)
        if (i < completedCount) {
            branchPaint.color = color;
        } else if (i == completedCount) {
            branchPaint.color = color.withOpacity(0.8);
        } else {
            branchPaint.color = AppColors.neutralOutline.withOpacity(0.3);
        }

        canvas.drawPath(branchPath, branchPaint);

        // Solid Toy Leaves
        if (i < completedCount && i % 2 == 0) {
            final leafPos = Offset((centerX + nodePos.dx) / 2, nodePos.dy);
            _drawLeaf(canvas, leafPos);
        }
    }
  }

  void _drawLeaf(Canvas canvas, Offset pos) {
    final paint = Paint()
      ..color = AppColors.successFace
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(pos, 6, paint);
  }

  Color _brightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return oldDelegate.completedCount != completedCount || oldDelegate.nodePositions.length != nodePositions.length;
  }
}
