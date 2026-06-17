import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

sealed class AppTextStyles {
  static const title = TextStyle(
    color: AppColors.text,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  static const sectionTitle = TextStyle(
    color: AppColors.text,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static const cardTitle = TextStyle(
    color: AppColors.text,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const body = TextStyle(
    color: AppColors.text,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const muted = TextStyle(
    color: AppColors.muted,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const label = TextStyle(
    color: AppColors.text,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
}
