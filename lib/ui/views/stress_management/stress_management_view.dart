import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'stress_management_viewmodel.dart';

class StressManagementView extends StackedView<StressManagementViewModel> {
  const StressManagementView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StressManagementViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stress Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 8,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal.shade700,
                Colors.teal.shade400,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA), // Light background for contrast
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Mindful Breathing Exercises
              _buildSectionCard(
                context: context,
                title: "🧘‍♀️ Mindful Breathing Exercises",
                subtitle: "Reduce Cortisol & Improve Insulin Sensitivity",
                gradientColors: [Colors.blue.shade100, Colors.blue.shade300],
                titleColor: Colors.blue.shade800,
                icon: Icons.air,
                items: viewModel.breathingExercises,
              ),

              30.verticalSpace,

              // Section 2: Meditation & Relaxation Techniques
              _buildSectionCard(
                context: context,
                title: "🧘 Meditation & Relaxation Techniques",
                gradientColors: [
                  Colors.purple.shade100,
                  Colors.purple.shade300
                ],
                titleColor: Colors.purple.shade800,
                icon: Icons.self_improvement,
                items: viewModel.meditationTechniques,
              ),

              30.verticalSpace,

              // Section 3: Physical Activity for Stress Relief
              _buildSectionCard(
                context: context,
                title: "🏃‍♂️ Physical Activity for Stress Relief",
                gradientColors: [Colors.green.shade100, Colors.green.shade300],
                titleColor: Colors.green.shade800,
                icon: Icons.directions_run,
                items: viewModel.physicalActivities,
              ),

              30.verticalSpace,

              // Section 4: Sleep Hygiene & Relaxation Before Bed
              _buildSectionCard(
                context: context,
                title: "😴 Sleep Hygiene & Relaxation Before Bed",
                gradientColors: [
                  Colors.indigo.shade100,
                  Colors.indigo.shade300
                ],
                titleColor: Colors.indigo.shade800,
                icon: Icons.nightlight_round,
                items: viewModel.sleepHygieneTips,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a section card
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<Color> gradientColors,
    required Color titleColor,
    required IconData icon,
    required List<String> items,
  }) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: titleColor,
                  size: 28.sp,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              5.verticalSpace,
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ],
            15.verticalSpace,
            ...items.map(
              (item) => _buildListItem(
                context: context,
                item: item,
                borderColor: titleColor,
                backgroundColor: gradientColors[0].withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a list item card
  Widget _buildListItem({
    required BuildContext context,
    required String item,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: BorderSide(color: borderColor, width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(15.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: borderColor,
                size: 24.sp,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  StressManagementViewModel viewModelBuilder(BuildContext context) =>
      StressManagementViewModel();
}
