import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../widgets/custom_nav_screens_appBar.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      key: viewModel.scaffoldKey,
      backgroundColor: AppColors.gray50,
      body: viewModel.bottomNavScreens[viewModel.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.currentIndex,
        type: BottomNavigationBarType.fixed,
        items: viewModel.getBottomNavBarItems(),
        onTap: (index) {
          viewModel.setIndex(index);
          viewModel.notifyListeners();
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.xsRegular2.copyWith(
          color: AppColors.red600,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTextStyles.xsRegular2.copyWith(
          color: AppColors.gray400,
          fontSize: 11.sp,
        ),
        selectedItemColor: AppColors.red600,
        unselectedItemColor: AppColors.gray400,
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}
