import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gluco_coach/ui/common/app_colors.dart';

import 'package:stacked/stacked.dart';

import '../../../common/app_styles.dart';
import '../../../common/assets.dart';
import '../../custom_image_widget.dart';
import 'custom_drawer_model.dart';

class CustomDrawer extends StackedView<CustomDrawerModel> {
  const CustomDrawer({
    super.key,
    required this.onCloseTap,
    required this.onProfile,
    required this.onSetting,
    required this.onTerms,
    required this.onPrivacy,
    required this.onRateUs,
    required this.onContactUs,
    // required this.onLogOut,
  });
  final void Function()? onCloseTap;
  final void Function()? onProfile;
  final void Function()? onSetting;
  final void Function()? onTerms;
  final void Function()? onPrivacy;
  final void Function()? onRateUs;
  final void Function()? onContactUs;
  // final void Function()? onLogOut;

  @override
  Widget builder(
    BuildContext context,
    CustomDrawerModel viewModel,
    Widget? child,
  ) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      width: 0.8.sw,
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, top: 62.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: onCloseTap,
                    child: Icon(
                      Icons.clear,
                      color: AppColors.gray800,
                      size: 25,
                    )),
                20.horizontalSpace,
                8.horizontalSpace,
                Text(
                  'Gluco Coach ',
                  style: AppTextStyles.xlSemibold.copyWith(
                    color: AppColors.tealDark,
                  ),
                ),
              ],
            ),
            36.verticalSpace,
            DrawerItem(
              iconPath: Icons.person,
              label: 'Profile',
              onTap: onProfile,
            ),
            32.verticalSpace,
            DrawerItem(
              iconPath: Icons.settings,
              label: 'Settings',
              onTap: onSetting,
            ),
            32.verticalSpace,
            DrawerItem(
              iconPath: Icons.star,
              label: 'Rate Us',
              onTap: onRateUs,
            ),
            32.verticalSpace,
            const Spacer(),
            DrawerItem(
              iconPath: Icons.logout,
              label: 'Log Out',
              onTap: () {
                // viewModel.showLogOutDialog();
              },
            ),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  CustomDrawerModel viewModelBuilder(
    BuildContext context,
  ) =>
      CustomDrawerModel();
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  final IconData iconPath;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconPath,
            size: 25,
          ),
          12.horizontalSpace,
          Text(
            label,
            style: AppTextStyles.mRegular.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
