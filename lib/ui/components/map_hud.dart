import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/brand_colors.dart';
import '../theme/metrics.dart';
import '../theme/playful_icons.dart';

class MapHUD extends StatelessWidget {
  const MapHUD({
    super.key,
    required this.streak,
    required this.hearts,
    required this.gems,
  });

  final int streak;
  final int hearts;
  final int gems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE5E5E5),
            width: 2.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              icon: PlayfulIcons.fire,
              value: streak.toString(),
              color: AppColors.duoRed, // Streaks often red/orange
            ),
            _buildStatItem(
              icon: Icons.favorite_rounded,
              value: hearts.toString(),
              color: AppColors.duoRed,
            ),
            _buildStatItem(
              icon: Icons.diamond_rounded,
              value: gems.toString(),
              color: AppColors.duoBlue, // Gems are blue in Duo
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
