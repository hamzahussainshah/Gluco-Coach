import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/app_colors.dart';

void showCustomTopSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = AppColors.gray800,
  Duration duration = const Duration(seconds: 2),
}) {
  // Create an OverlayEntry
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 60.h, // 50 pixels from the top
      left: 16.w,
      right: 16.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.checkmark_alt_circle,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the OverlayEntry into the Overlay
  Overlay.of(context).insert(overlayEntry);

  // Remove the OverlayEntry after the specified duration
  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}
