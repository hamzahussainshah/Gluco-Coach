import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gluco_coach/ui/common/app_colors.dart';
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
    List<String> dietLines = viewModel.dietPlan.split('\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meal Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.fetchUserResponses,
            tooltip: "Refresh Plan",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: viewModel.isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.tealDark),
                      SizedBox(height: 16),
                      Text(
                        "Crafting Your Meal Plan...",
                        style:
                            TextStyle(fontSize: 16, color: AppColors.tealDark),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (imageUrl != null) ...[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                                height: 1.5,
                                              ),
                                              children: [
                                                TextSpan(text: textBefore),
                                                TextSpan(
                                                  text: 'Recipe',
                                                  style: const TextStyle(
                                                    color: Colors.teal,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          final Uri url =
                                                              Uri.parse(link);
                                                          if (await canLaunchUrl(
                                                              url)) {
                                                            await launchUrl(
                                                                url);
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Could not launch $link')),
                                                            );
                                                          }
                                                        },
                                                ),
                                                TextSpan(text: textAfter),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                // Non-meal lines (e.g., headers, tips)
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Text(
                                    line,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  MealPlanViewModel viewModelBuilder(BuildContext context) =>
      MealPlanViewModel();
}
