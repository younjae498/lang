class AppMetrics {
  // Fun & Playful Design System Metrics
  
  // Border Radius - 모든 모서리를 둥글게 (16px~24px+)
  static const double radiusButton = 24.0; // 버튼용 큰 radius
  static const double radiusCard = 20.0; // 카드/타일용
  static const double radiusSmall = 16.0; // 작은 요소용
  static const double radiusChip = 100.0; // 완전히 둥근 칩/뱃지
  
  // 3D Button Depth (Claymorphism)
  static const double buttonHeight = 56.0;
  static const double buttonDepth = 6.0; // 버튼 하단 3D 그림자 깊이
  static const double buttonPressOffset = 4.0; // 눌렀을 때 이동 거리
  
  // Tile Metrics
  static const double tileHeight = 84.0;
  static const double tileDepth = 8.0; // 타일 3D 깊이
  static const double tilePressOffset = 6.0;
  
  // Spacing
  static const double spacingXS = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Stroke/Border Width
  static const double strokeThin = 2.0;
  static const double strokeThick = 3.0;
  
  // Icon Sizes (두툼한 solid 아이콘용)
  static const double iconSmall = 20.0;
  static const double iconMedium = 28.0;
  static const double iconLarge = 36.0;
  
  // Legacy compatibility
  static const double baseHeight = buttonDepth;
  static const double pressedOffset = buttonPressOffset;
  static const double borderRadius = radiusButton;
  static const double strokeWidth = strokeThin;
  static const double tileSpacing = spacingS;
}
