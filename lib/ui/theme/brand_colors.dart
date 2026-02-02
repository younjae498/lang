import 'package:flutter/material.dart';

class AppColors {
  // ============ Fennec Fox Theme Palette ============
  
  // Base Colors from Image
  static const Color fennecSand = Color(0xFFFFF8E1);     // Warm Cream
  static const Color fennecGold = Color(0xFFFFB74D);     // Orange-Gold
  static const Color fennecGoldBase = Color(0xFFF57C00); // Darker Gold
  static const Color fennecBrown = Color(0xFF5D4037);    // Dark Brown
  static const Color fennecGreen = Color(0xFF66BB6A);    // Eye Green
  static const Color fennecGreenBase = Color(0xFF388E3C);
  
  // Character Match Palette
  static const Color foxCream = Color(0xFFFFE0B2);      // Main Body/Face (Light Orange Cream)
  static const Color foxBrown = Color(0xFF5D4037);      // Paws/Ears (Dark Chocolate)
  static const Color foxGreen = Color(0xFF43A047);      // Eyes (Emerald)
  static const Color foxOrange = Color(0xFFFB8C00);     // Deep Fur Shadow

  // Mapped Authentic Colors
  static const Color duoGreen = fennecGreen;
  static const Color duoGreenBase = fennecGreenBase;
  
  static const Color duoBlue = fennecGold;   // Primary Active Color
  static const Color duoBlueBase = fennecGoldBase;
  
  static const Color duoGold = Color(0xFFFFCA28);
  static const Color duoGoldBase = Color(0xFFFF8F00);
  
  static const Color duoRed = Color(0xFFEF5350);
  static const Color duoRedBase = Color(0xFFC62828);

  // Logical Wrappers
  static const Color successFace = duoGreen; 
  static const Color successBase = duoGreenBase;
  
  static const Color energyFace = duoBlue;
  static const Color energyBase = duoBlueBase;
  
  static const Color warningFace = duoGold;
  static const Color warningBase = duoGoldBase;
  
  static const Color errorFace = duoRed;
  static const Color errorBase = duoRedBase;

  // Design 2.0 Mappings
  static const Color orangeFace = duoBlue; 
  static const Color yellowFace = duoGold;
  static const Color vividPink = Color(0xFFF48FB1);
  
  static const Color skipLavender = fennecGold;
  static const Color skipDarkBase = fennecGoldBase;
  static const Color tooltipDark = fennecBrown; // Brown Tooltips

  // Neutral/Default
  static const Color neutralFace = Color(0xFFFFFFFF); 
  static const Color neutralBase = Color(0xFFE5E5E5); 
  static const Color neutralOutline = Color(0xFFE5E5E5);
  static const Color lockedGray = Color(0xFFD7CCC8); // Warm Gray

  // Text Colors
  static const Color textMain = Colors.white; 
  static const Color textSecondary = Color(0xFF777777); 
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF0F1F2C);

  // Background Colors
  static const Color backgroundPure = duoDarkBg; 
  static const Color backgroundLight = duoPanelBg;

  // ============ Duolingo Dark Mode (Dashboard) ============
  static const Color duoDarkBg = Color(0xFF0F1F2C);      // Original Duo Navy
  static const Color duoSidebarBg = Color(0xFF131F24);   // Darker Sidebar
  static const Color duoPanelBg = Color(0xFF1C252E);     // Panel BG
  static const Color duoBorder = Color(0xFF37464F);      // Border
}
