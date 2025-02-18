import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';

class CustomIconTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final validate;
  final onChanged;
  final onTap;
  final String? iconPreText;
  const CustomIconTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validate,
      this.onChanged,
      this.onTap,
      this.iconPreText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      onChanged: onChanged,
      validator: validate,
      showCursor: false,
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          size: 30,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 16.w,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.mRegular.copyWith(
          color: AppColors.cursorColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),

          // borderSide: const BorderSide(color: AppColors.red300),
          borderSide: const BorderSide(color: AppColors.gray200, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColors.gray200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.gray300, width: 1),
        ),
      ),
    );
  }
}
