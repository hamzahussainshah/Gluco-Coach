import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:numberpicker/numberpicker.dart';

import 'workout_plan_viewmodel.dart';

class WorkoutPlanView extends StackedView<WorkoutPlanViewModel> {
  const WorkoutPlanView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WorkoutPlanViewModel viewModel,
    Widget? child,
  ) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.back();
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE3ECFF),
                Color(0xFFB3CFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context)
                              .padding
                              .top, // Ensure it fills the screen height
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Daily Workout Plan",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A3C6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Only show content if not busy
                        if (!viewModel.isBusy) ...[
                          // Content based on viewModel state
                          viewModel.currentExercise == null
                              ? Center(
                                  child: Text(
                                    "No exercises available for today.",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              : viewModel.currentExercise!['name'] ==
                                      'No Exercise'
                                  ? Center(
                                      child: Text(
                                        "No valid exercises available.",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      child: Column(
                                        children: [
                                          _buildExerciseCard(
                                            name: viewModel
                                                .currentExercise!['name']!,
                                            duration: viewModel
                                                .currentExercise!['duration']!,
                                            description:
                                                viewModel.currentExercise![
                                                    'description']!,
                                            videos: viewModel
                                                .currentExercise!['videos'],
                                            onVideoTap: (url) {
                                              viewModel.launchVideo(url);
                                            },
                                          ),
                                          20.verticalSpace,
                                          // Show the checkbox section only if it's not a rest day
                                          if (viewModel.currentExercise![
                                                      'duration'] !=
                                                  '' ||
                                              !viewModel
                                                  .currentExercise!['name']
                                                  .toLowerCase()
                                                  .contains('rest')) ...[
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: viewModel
                                                      .isExerciseCompleted,
                                                  onChanged: viewModel
                                                          .isExerciseCompleted
                                                      ? null // Disable interaction if already checked
                                                      : (value) {
                                                          if (value == true) {
                                                            _showTimePickerDialog(
                                                                context,
                                                                viewModel);
                                                          } else {
                                                            viewModel
                                                                .setExerciseCompleted(
                                                                    false);
                                                          }
                                                        },
                                                ),
                                                Text(
                                                  "I have completed exercise",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color:
                                                        const Color(0xFF1A3C6D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                        ],
                      ],
                    ),
                  ),
                ),
                // Loader overlay
                if (viewModel.isBusy)
                  Container(
                    color: Colors.black.withOpacity(
                        0.3), // Optional: Add a semi-transparent overlay
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required String name,
    required String duration,
    required String description,
    List<Map<String, String>>? videos,
    required Function(String) onVideoTap,
  }) {
    bool isRestDay = duration.isEmpty && name.toLowerCase().contains('rest');

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRestDay ? Icons.self_improvement : Icons.fitness_center,
                  color: isRestDay ? Colors.green : Colors.blueAccent,
                  size: 30.sp,
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A3C6D),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              duration.isNotEmpty ? "Duration: $duration" : "Rest Day",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            if (videos != null && videos.isNotEmpty) ...[
              SizedBox(height: 15.h),
              ...videos.map((video) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: GestureDetector(
                    onTap: () => onVideoTap(video['url']!),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            video['thumbnail']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 100.w,
                              height: 60.h,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          video['title']!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePickerDialog(
      BuildContext context, WorkoutPlanViewModel viewModel) async {
    int hours = 0;
    int minutes = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Exercise Duration"),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Hours"),
                  NumberPicker(
                    value: hours,
                    minValue: 0,
                    maxValue: 23,
                    selectedTextStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    onChanged: (value) {
                      hours = value;
                      (context as Element)
                          .markNeedsBuild(); // Rebuild the dialog
                    },
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Minutes"),
                  NumberPicker(
                    value: minutes,
                    minValue: 0,
                    maxValue: 59,
                    selectedTextStyle: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    onChanged: (value) {
                      minutes = value;
                      (context as Element)
                          .markNeedsBuild(); // Rebuild the dialog
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.setExerciseCompleted(false); // Uncheck if canceled
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int totalMinutes = (hours * 60) + minutes;
                if (totalMinutes == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select a valid duration")),
                  );
                  viewModel.setExerciseCompleted(false);
                  Navigator.of(context).pop();
                  return;
                }
                viewModel.logExercise(totalMinutes);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
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
