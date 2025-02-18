import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';

final commonMarkdownStyleSheet = MarkdownStyleSheet(
  h1: AppTextStyles.lSemibold.copyWith(
    color: AppColors.gray800,
    fontSize: 22.sp,
    height: 1.5,
  ),
  h2: AppTextStyles.mSemibold.copyWith(
    color: AppColors.gray800,
    fontSize: 20.sp,
    height: 1.4,
  ),
  h3: AppTextStyles.sSemibold.copyWith(
    color: AppColors.gray800,
    fontSize: 18.sp,
    height: 1.3,
  ),
  p: AppTextStyles.sRegular.copyWith(
    color: AppColors.blackColor,
    fontSize: 16.sp,
    height: 1.6, // Line height for better readability
  ),
  listBullet: AppTextStyles.sRegular.copyWith(
    color: AppColors.blackColor,
    fontSize: 16.sp,
  ),
  a: AppTextStyles.sRegular.copyWith(
    color: Colors.blue,
    fontSize: 16.sp,
  ),
);
