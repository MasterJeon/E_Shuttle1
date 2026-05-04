import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const _base = TextStyle(color: AppColors.onBackground);

  static final h1 = _base.copyWith(fontSize: 28, fontWeight: FontWeight.bold);
  static final h2 = _base.copyWith(fontSize: 22, fontWeight: FontWeight.w600);
  static final h3 = _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);
  static final body = _base.copyWith(fontSize: 14);
  static final bodySmall = _base.copyWith(fontSize: 12, color: AppColors.onSurface);
  static final label = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final button = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onPrimary);
}