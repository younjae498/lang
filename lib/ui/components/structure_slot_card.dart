import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
import '../theme/metrics.dart';

class StructureSlotCard extends StatelessWidget {
  const StructureSlotCard({
    super.key,
    required this.slotName,
    required this.content,
    this.color = AppColors.energyFace,
    this.isLocked = false,
  });

  final String slotName;
  final String content;
  final Color color;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final faceColor = isLocked ? const Color(0xFFE0E0E0) : color;
    final baseColor = isLocked ? const Color(0xFFBDBDBD) : _getDarkerColor(color);
    const double thickness = 6.0;

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12, bottom: thickness),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // BASE (3D Depth)
          Positioned(
            top: thickness, left: 0, right: 0, bottom: -thickness,
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
              ),
            ),
          ),
          
          // FACE (Main Card - Solid Color)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: faceColor,
              borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), 
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slot Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(AppMetrics.radiusChip),
                  ),
                  child: Text(
                    slotName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                // Content
                isLocked
                    ? const Icon(Icons.lock_rounded, size: 32, color: Colors.white70)
                    : Text(
                        content,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}
