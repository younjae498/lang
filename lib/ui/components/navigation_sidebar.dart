import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.duoSidebarBg,
        border: Border(
          right: BorderSide(color: AppColors.duoBorder, width: 2),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo
          const Text(
            'duolingo',
            style: TextStyle(
              color: AppColors.duoGreen,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),
          // Nav Items
          _buildNavItem(Icons.home_rounded, '학습', true),
          _buildNavItem(Icons.abc_rounded, '문자', false),
          _buildNavItem(Icons.shield_rounded, '리더보드', false),
          _buildNavItem(Icons.calendar_month_rounded, '퀘스트', false),
          _buildNavItem(Icons.storefront_rounded, '스토어', false),
          _buildNavItem(Icons.person_rounded, '프로필', false),
          _buildNavItem(Icons.more_horiz_rounded, '더 보기', false),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColors.duoBlue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: AppColors.duoBlue, width: 2) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? AppColors.duoBlue : AppColors.textSecondary, size: 28),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.duoBlue : AppColors.textWhite,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
