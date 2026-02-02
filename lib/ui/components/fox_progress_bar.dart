import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';

class FoxProgressBar extends StatelessWidget {
  const FoxProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 16.0,
    this.color = AppColors.duoGreen,
  });

  final int current;
  final int total;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double progress = (current / total).clamp(0.0, 1.0);
    const double radius = 100.0;
    
    return Container(
      width: double.infinity,
      height: height + 4, // Account for 3D depth
      decoration: BoxDecoration(
        color: AppColors.duoBorder, // Track color
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        children: [
          // 3D BASE
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: height + 4,
              decoration: BoxDecoration(
                color: _getDarkerColor(color),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
          // FACE
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Stack(
                children: [
                   // TOP HIGHLIGHT
                  Positioned(
                    top: height * 0.2,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDarkerColor(Color color) {
    if (color == AppColors.duoGreen) return AppColors.duoGreenBase;
    if (color == AppColors.duoBlue) return AppColors.duoBlueBase;
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  }
}
