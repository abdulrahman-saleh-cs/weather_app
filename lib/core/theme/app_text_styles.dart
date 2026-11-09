import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    color: AppColors.white,
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );

  static const TextStyle titleLarge = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelMedium = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bodyMediumMuted = TextStyle(
    color: AppColors.white.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}
