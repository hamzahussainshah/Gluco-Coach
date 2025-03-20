import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'workout_plan_viewmodel.dart';

class WorkoutPlanView extends StackedView<WorkoutPlanViewModel> {
  const WorkoutPlanView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WorkoutPlanViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3ECFF),
      appBar: AppBar(
        title: Text(
          "Monthly Workout Plan",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A3C6D),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: ListView.builder(
                itemCount: viewModel.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = viewModel.exercises[index];

                  if (exercise.containsKey('week')) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
                      child: Text(
                        exercise['week']!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    );
                  }

                  return _buildExerciseCard(
                    name: exercise['name']!,
                    duration: exercise['duration']!,
                    description: exercise['description']!,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildExerciseCard({
    required String name,
    required String duration,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.fitness_center, color: Colors.blue, size: 30.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A3C6D),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Duration: $duration",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  WorkoutPlanViewModel viewModelBuilder(BuildContext context) =>
      WorkoutPlanViewModel();

  @override
  void onViewModelReady(WorkoutPlanViewModel viewModel) {
    viewModel.fetchUserWorkoutPlan();
  }
}
