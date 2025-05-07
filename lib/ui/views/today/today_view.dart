import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'today_viewmodel.dart';

class TodayView extends StackedView<TodayViewModel> {
  const TodayView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TodayViewModel viewModel,
    Widget? child,
  ) {
    // Get the screen height for dynamic sizing
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE3ECFF), // Light blue background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile & Greeting Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Good Morning, ${viewModel.name}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(
                              0xFF1A3C6D), // Dark blue for contrast
                        ),
                      ),
                      PopupMenuButton<int>(
                        onSelected: (value) {
                          // Handle any actions if needed (e.g., logout)
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            enabled:
                                false, // Disable interaction with the item (we just want to display info)
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Circular avatar with the first letter of the username
                                  CircleAvatar(
                                    radius: 30.r,
                                    backgroundColor: Colors.teal,
                                    child: Text(
                                      viewModel.getFirstLetter(),
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  10.verticalSpace,
                                  // Username
                                  Text(
                                    viewModel.name ?? "User",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A3C6D),
                                    ),
                                  ),
                                  5.verticalSpace,
                                  // Email
                                  Text(
                                    viewModel.email ?? "No email available",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              color: Colors.blue, size: 28.sp),
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,

                  // Graph Section (Exercise Durations)
                  Container(
                    height: screenHeight *
                        0.35, // Dynamic height: 35% of screen height
                    width: double.infinity, // Take full width
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Exercise Duration",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A3C6D),
                              ),
                            ),
                            // Filter Dropdown
                            DropdownButton<String>(
                              value: viewModel.selectedFilter,
                              items: ['Weekly', 'Monthly']
                                  .map((filter) => DropdownMenuItem<String>(
                                        value: filter,
                                        child: Text(
                                          filter,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: const Color(0xFF1A3C6D),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  viewModel.setFilter(value);
                                }
                              },
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Expanded(
                          child: viewModel.exerciseSpots.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator())
                              : Padding(
                                  padding: EdgeInsets.only(
                                      right: 10
                                          .w), // Add padding to prevent overflow on the right
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment
                                          .spaceEvenly, // Evenly space bars
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine: (value) =>
                                            FlLine(
                                          color: Colors.grey.withOpacity(0.2),
                                          strokeWidth: 1,
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40.w,
                                            interval: viewModel.maxDuration /
                                                5, // Dynamic interval
                                            getTitlesWidget: (value, meta) =>
                                                Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30
                                                .h, // Reserve space for bottom titles
                                            getTitlesWidget: (value, meta) {
                                              if (viewModel.selectedFilter ==
                                                  'Weekly') {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.h),
                                                  child: Text(
                                                    [
                                                      'Mon',
                                                      'Tue',
                                                      'Wed',
                                                      'Thu',
                                                      'Fri',
                                                      'Sat',
                                                      'Sun'
                                                    ][value.toInt()],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                // Monthly view: Show week numbers or dates
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.h),
                                                  child: Text(
                                                    'W${value.toInt() + 1}', // Week 1, Week 2, etc.
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      minY: 0, // Start at 0 for duration
                                      maxY: viewModel
                                          .maxDuration, // Dynamic max duration
                                      barGroups: viewModel.exerciseSpots
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        FlSpot spot = entry.value;
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              toY: spot.y,
                                              color: Colors.teal,
                                              width: 12
                                                  .w, // Reduced width to prevent overflow
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      extraLinesData: ExtraLinesData(
                                        horizontalLines: [
                                          HorizontalLine(
                                            y: viewModel.maxDuration,
                                            color: Colors
                                                .transparent, // Invisible line to ensure padding at the top
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  25.verticalSpace,

                  // Workout & Meal Plan Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(
                        title: "Workout Plan",
                        color: const Color(0xFF3B82F6), // Blue shade
                        icon: Icons.fitness_center,
                        height: screenHeight *
                            0.15, // Dynamic height: 15% of screen height
                        onTap: () {
                          viewModel.navigateToWorkoutPlanView();
                        },
                      ),
                      10.horizontalSpace,
                      _buildCategoryCard(
                        title: "Diet & Meal Plan",
                        color: const Color(0xFFEF4444), // Red shade
                        icon: Icons.restaurant,
                        height: screenHeight *
                            0.15, // Dynamic height: 15% of screen height
                        onTap: () {
                          viewModel.navigateToMealPlanView();
                        },
                      ),
                    ],
                  ),
                  25.verticalSpace,

                  // Additional Services
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildServiceCard(
                        title: "Stress Management",
                        icon: Icons
                            .self_improvement, // Icon for stress management
                        color: const Color(
                            0xFF6B7280), // Gray shade for stress management
                        height: screenHeight *
                            0.12, // Dynamic height: 12% of screen height
                        onTap: () {
                          viewModel.navigateToStressManagementView();
                        },
                      ),
                      10.horizontalSpace,
                      _buildServiceCard(
                        title: "Generate Report",
                        icon: CupertinoIcons.doc_fill,
                        color: const Color(
                            0xFF10B981), // Green shade for log exercise
                        height: screenHeight *
                            0.12, // Dynamic height: 12% of screen height
                        onTap: () {
                          viewModel.navigateToGenerateReport();
                        },
                      ),
                    ],
                  ),
                  // No need for extra vertical space at the bottom since we're filling the screen
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Function to create main category cards (Workout & Diet)
  Widget _buildCategoryCard({
    required String title,
    required Color color,
    required IconData icon,
    required double height,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height, // Dynamic height passed as parameter
          margin: EdgeInsets.symmetric(
              horizontal: 0.w), // Removed margin to use full width
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40.sp),
              10.verticalSpace,
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to create small service cards with enhanced styling
  Widget _buildServiceCard({
    required String title,
    required IconData icon,
    required Color color,
    required double height,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height, // Dynamic height passed as parameter
          margin: EdgeInsets.symmetric(
              horizontal: 0.w), // Removed margin to use full width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: color.withOpacity(0.5), // Border color matching the theme
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
              10.verticalSpace,
              Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: const Color(0xFF1A3C6D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  TodayViewModel viewModelBuilder(BuildContext context) => TodayViewModel();
}
