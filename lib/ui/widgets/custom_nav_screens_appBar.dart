import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors.dart';
import '../common/app_styles.dart';
import '../common/assets.dart';
import 'custom_image_widget.dart';

class CustomNavScreensAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomNavScreensAppBar({
    required this.title,
    required this.onHambergerTap,
    required this.onNotificationTap,
    super.key,
  });
  final String title;
  final void Function()? onHambergerTap;
  final void Function()? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.red500,
      leadingWidth: 24.w + 24.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 24.w),
        child: InkWell(
            onTap: onHambergerTap,
            child: Icon(
              Icons.menu,
            )),
      ),
      title: Text(
        title,
        style: AppTextStyles.xlSemibold.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.r),
        ),
      ),
      actions: [
        InkWell(onTap: onNotificationTap, child: Icon(CupertinoIcons.bell)),
        24.horizontalSpace,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
