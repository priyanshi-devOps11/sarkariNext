import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const h1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
  static const h2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const h3 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.normal,
    color: AppColors.textPrimary, height: 1.5,
  );
  static const bodySmall = TextStyle(
    fontSize: 12, color: AppColors.textSecondary, height: 1.4,
  );
  static const label = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  static const button = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3,
  );
}