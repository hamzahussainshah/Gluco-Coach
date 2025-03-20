import 'package:fl_chart/fl_chart.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFE3ECFF), // Light blue background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: SingleChildScrollView(
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
                        color:
                        const Color(0xFF1A3C6D), // Dark blue for contrast
                      ),
                    ),
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.white,
                      child:
                      Icon(Icons.person, color: Colors.blue, size: 28.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Graph Section (Blood Sugar Levels)
                Container(
                  height: 200.h, // Increased height for better graph visibility
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
                      Text(
                        "Blood Sugar Levels (mg/dL)",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A3C6D),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40.w,
                                  getTitlesWidget: (value, meta) => Text(
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
                                  getTitlesWidget: (value, meta) => Text(
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
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: 6,
                            minY: 50,
                            maxY: 200,
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  const FlSpot(0, 120), // Mon
                                  const FlSpot(1, 130), // Tue
                                  const FlSpot(2, 110), // Wed
                                  const FlSpot(3, 150), // Thu
                                  const FlSpot(4, 140), // Fri
                                  const FlSpot(5, 125), // Sat
                                  const FlSpot(6, 135), // Sun
                                ],
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3.w,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),

                // Workout & Meal Plan Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryCard(
                      title: "Workout Plan",
                      color: const Color(0xFF3B82F6), // Blue shade
                      icon: Icons.fitness_center,
                      onTap: () {
                        viewModel.navigateToWorkoutPlanView();
                      },
                    ),
                    _buildCategoryCard(
                      title: "Diet & Meal Plan",
                      color: const Color(0xFFEF4444), // Red shade
                      icon: Icons.restaurant,
                      onTap: () {
                        viewModel.navigateToMealPlanView();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 25.h),

                // Additional Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceCard("Stress Management", () {
                      viewModel.navigateToStressManagementView();
                    }),
                    _buildServiceCard("Guided Meditation", () {
                      // Add navigation or action
                    }),
                  ],
                ),
              ],
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
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
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
              SizedBox(height: 10.h),
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

  /// Function to create small service cards
  Widget _buildServiceCard(String title, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: const Color(0xFF1A3C6D),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  TodayViewModel viewModelBuilder(BuildContext context) => TodayViewModel();
}
