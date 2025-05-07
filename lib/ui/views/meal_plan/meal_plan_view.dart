import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gluco_coach/ui/common/app_colors.dart';
import 'package:gluco_coach/ui/widgets/custom_elevated_button.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'meal_plan_viewmodel.dart';

class MealPlanView extends StackedView<MealPlanViewModel> {
  const MealPlanView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MealPlanViewModel viewModel,
    Widget? child,
  ) {
    // Split diet plan into lines and filter out empty or whitespace-only lines
    List<String> dietLines = viewModel.dietPlan
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meal Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Scrollable content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.local_dining,
                                color: Colors.teal, size: 30),
                            12.horizontalSpace,
                            const Expanded(
                              child: Text(
                                "Welcome to Your Custom Diet Plan!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    // Diet Plan Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Diet Plan",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            12.verticalSpace,
                            ...dietLines.map((line) {
                              String? imageUrl =
                                  viewModel.getMealImageUrl(line);
                              // Parse meal lines for clickable links
                              if (line.contains('(Recipe: ') &&
                                  line.contains(')')) {
                                int start = line.indexOf('(Recipe: ') + 9;
                                int end = line.indexOf(')', start);
                                String textBefore =
                                    line.substring(0, start - 9);
                                String link = line.substring(start, end);
                                String textAfter = line.substring(end + 1);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: Colors.teal.shade200,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (imageUrl != null) ...[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: CachedNetworkImage(
                                              imageUrl: imageUrl,
                                              width: 60.w,
                                              height: 60.h,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          12.horizontalSpace,
                                        ],
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black87,
                                                height: 1.5,
                                              ),
                                              children: [
                                                TextSpan(text: textBefore),
                                                WidgetSpan(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final Uri url =
                                                          Uri.parse(link);
                                                      if (await canLaunchUrl(
                                                          url)) {
                                                        await launchUrl(url);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Could not launch $link')),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.w,
                                                              vertical: 4.h),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.w),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .teal.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.r),
                                                        border: Border.all(
                                                          color: Colors
                                                              .teal.shade300,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Recipe',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors
                                                              .teal.shade800,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(text: textAfter),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              // Non-meal lines (e.g., headers, tips, metadata)
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    line,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: line.contains(
                                              'No suitable meal found')
                                          ? Colors.red.shade600
                                          : Colors.black87,
                                      height: 1.5,
                                      fontWeight:
                                          line.toLowerCase().contains('day') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('tip') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('diabetes') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('activity') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('dietary') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('goal') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('allergies') ||
                                                  line
                                                      .toLowerCase()
                                                      .contains('note')
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    80.verticalSpace, // Add extra space at the bottom to avoid overlap with the button
                  ],
                ),
              ),
            ),
            // Button at the bottom
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: CustomElevatedButton(
                text: "Try Another Meal Plan",
                onPressed: () {
                  viewModel.fetchUserResponses();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  MealPlanViewModel viewModelBuilder(BuildContext context) =>
      MealPlanViewModel();
}
