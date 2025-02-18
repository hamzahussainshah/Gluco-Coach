import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';
import '../common/assets.dart';
import 'custom_image_widget.dart';

class CustomBackIconAppbar extends StatelessWidget {
  final VoidCallback onTapBackIcon;
  final String title;
  const CustomBackIconAppbar(
      {super.key, required this.onTapBackIcon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTapBackIcon,
          child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15.r,
              child: Icon(
                CupertinoIcons.arrowshape_turn_up_left,
                color: AppColors.gray800,
                size: 20.sp,
              )),
        ),
        // InkWell(
        //   onTap: onTapBackIcon,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: 15.r,
        //     child: CustomImageView(
        //       svgPath: AppIcons.backArrow,
        //       height: 12.h,
        //       width: 5.w,
        //     ),
        //   ),
        // ),
        Text(
          title,
          style: AppTextStyles.xlSemibold.copyWith(
            color: AppColors.gray800,
          ),
        ),
        20.horizontalSpace,
      ],
    );
  }
}
