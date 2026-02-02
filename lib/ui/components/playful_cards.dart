import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/metrics.dart';

/// 화면 중앙에 떠 있는 느낌의 카드 (학습 문제용) - Solid Claymorphism
class FloatingQuestionCard extends StatelessWidget {
  const FloatingQuestionCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding,
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    const double thickness = 8.0;
    
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // BASE (3D Depth)
            Positioned(
              top: thickness, left: 0, right: 0, bottom: -thickness,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.neutralOutline.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
                ),
              ),
            ),
            
            // FACE
            Container(
              padding: padding ?? const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
                border: Border.all(
                  color: AppColors.neutralOutline.withOpacity(0.2), 
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// 콤팩트한 정보 카드 (단어 카드, 문법 카드 등)
class CompactCard extends StatelessWidget {
  const CompactCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.isSelected = false,
    this.height,
    this.width,
  });

  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final faceColor = color ?? AppColors.backgroundLight;
    final baseColor = _getDarkerColor(faceColor);
    const double thickness = 6.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height != null ? height! + thickness : null,
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // BASE
            Positioned(
              top: thickness, left: 0, right: 0, bottom: -thickness,
              child: Container(
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(AppMetrics.radiusSmall),
                ),
              ),
            ),
            
            // FACE
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: height,
              width: width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: faceColor,
                borderRadius: BorderRadius.circular(AppMetrics.radiusSmall),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black.withOpacity(0.05),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}

/// 섹션 헤더 카드 (Solid Design)
class SectionHeaderCard extends StatelessWidget {
  const SectionHeaderCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.color = AppColors.energyFace,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 1.0,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
