import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? Function(String?)? validate;
  final void Function(String)? onChanged;
  final bool obscure;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final void Function()? onTapSuffix;
  final String? suffixText;
  final Function(String)? onFieldSubmitted;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validate,
    this.prefixIcon,
    this.suffixIcon,
    this.obscure = false,
    this.keyboardType,
    this.onTap,
    this.suffixText,
    this.maxLines,
    this.focusNode,
    this.onFieldSubmitted,
    this.onTapSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      readOnly: onTap == null ? false : true,
      keyboardType: keyboardType,
      cursorColor: AppColors.blackColor,
      cursorHeight: 22.h,
      cursorWidth: 1.w,
      cursorRadius: Radius.circular(0.3.r),
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscure,
      controller: controller,
      obscuringCharacter: '*',
      onChanged: onChanged,
      validator: validate,
      focusNode: focusNode,
      style: AppTextStyles.mRegular,
      decoration: InputDecoration(
        suffix: Container(
          child: Text(
            suffixText ?? '',
            style: AppTextStyles.sMedium.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 16.w,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.mRegular.copyWith(
          color: const Color(0xFFA1A1AA),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: AppColors.gray200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          // borderSide: const BorderSide(color: AppColors.red300),
          borderSide: const BorderSide(color: AppColors.tealLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onTapSuffix,
                child: suffixIcon,
              )
            : null,
      ),
    );
  }
}
