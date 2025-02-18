import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle xlSemibold = GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF16141C),
  );
  static TextStyle xlRegular = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF16141C),
  );
  static TextStyle lSemibold = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF16141C),
  );
  static TextStyle mSemibold = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF16141C),
  );
  static TextStyle mMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
  static TextStyle mRegular = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
  static TextStyle sSemibold = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );
  static TextStyle sMedium = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
  static TextStyle sRegular = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );

  static TextStyle sRegularInter = GoogleFonts.inter(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );

  static TextStyle xSSemibold = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );
  static TextStyle xsMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
  static TextStyle xsRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );

  static TextStyle xsSemibold2 = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );
  static TextStyle xsMedium2 = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );
  static TextStyle xsRegular2 = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
  );
}
