import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'MicroSME';
  static const String appVersion = '1.0.0';

  // Database
  static const String dbName = 'microsme.db';
  static const int dbVersion = 2;

  // Defaults
  static const int defaultLowStockThreshold = 5;
  static const int defaultPointsPerAmount = 50; // 1 point per 50 THB
  static const int defaultRedemptionRate = 10; // 10 points for redemption
  static const int defaultRedemptionValue = 50; // 50 THB discount
  static const String currency = '฿';
  static const String currencyCode = 'THB';
}

/// App Colors
class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color secondary = Color(0xFF5856D6);
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color background = Color(0xFFF2F2F7);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color border = Color(0xFFC6C6C8);
  static const Color lowStock = Color(0xFFFF3B30);
}

/// Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Font Sizes
class AppFontSizes {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

/// Border Radius
class AppBorderRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double full = 9999.0;
}
