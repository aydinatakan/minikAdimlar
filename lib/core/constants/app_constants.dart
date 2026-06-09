import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors - More child friendly and fresh
  static const Color primary = Color(0xFF4ECDC4); 
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF7FFF7); // Mint Cream - Fresh
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color success = Color(0xFF6BCB77);
  static const Color error = Color(0xFFFF6B6B);
  static const Color inputBackground = Color(0xFFE8F3F1);
  
  // Design Gradients - Softer and more playful
  static const List<Color> splashGradient = [
    Color(0xFF4ECDC4),
    Color(0xFFFFD93D),
    Color(0xFFFF6B6B),
  ];

  static const List<Color> blueGradient = [Color(0xFF4D96FF), Color(0xFF6BCB77)];
  static const List<Color> violetGradient = [Color(0xFFA29BFE), Color(0xFF6C5CE7)];
  static const List<Color> orangeGradient = [Color(0xFFFFD93D), Color(0xFFFAB1A0)];
  static const List<Color> greenGradient = [Color(0xFF55E6C1), Color(0xFF58B19F)];
  static const List<Color> pinkGradient = [Color(0xFFFD79A8), Color(0xFFE84393)];
  static const List<Color> amberGradient = [Color(0xFFFFEAA7), Color(0xFFFDCB6E)];
}

class AppConstants {
  static const String appName = 'Minik Adımlar';
}
