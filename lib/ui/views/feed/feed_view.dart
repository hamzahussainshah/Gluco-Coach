import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'feed_viewmodel.dart';

class FeedView extends StackedView<FeedViewModel> {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FeedViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background for contrast
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons
                        .water_drop, // Use water_drop as a blood drop substitute
                    color: Colors.red.shade700, // Red color for blood
                    size: 28.sp,
                  ),
                  8.horizontalSpace,
                  Flexible(
                    child: Text(
                      "GlucoCoach App – Feed",
                      softWrap: true, // Allow text to wrap to the next line
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A3C6D),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              20.verticalSpace,

              // Category 1: Daily Blood Sugar Control Tips
              _buildSectionCard(
                context: context,
                title: "📌 Daily Blood Sugar Control Tips",
                titleColor: Colors.green.shade700,
                gradientColors: [Colors.green.shade100, Colors.green.shade300],
                children: [
                  _buildTipCard(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.green.shade400,
                      size: 24.sp,
                    ),
                    title: "Choose Fiber-Rich Foods",
                    description:
                        "Boost your blood sugar control by adding fiber-rich foods like oats, lentils, and veggies to your meals. They slow down sugar absorption and keep you full longer! ✅",
                    backgroundColor: Colors.green.shade50,
                    borderColor: Colors.green.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.green.shade400,
                      size: 24.sp,
                    ),
                    title: "Walk After Meals",
                    description:
                        "A simple 10-15 minute walk after eating can naturally lower blood sugar levels. Try it after lunch today! 🚶‍♂️💙",
                    backgroundColor: Colors.green.shade50,
                    borderColor: Colors.green.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.green.shade400,
                      size: 24.sp,
                    ),
                    title: "Prioritize Sleep",
                    description:
                        "Poor sleep can increase insulin resistance. Aim for 7-9 hours of quality sleep tonight to keep blood sugar in check! 😴✨",
                    backgroundColor: Colors.green.shade50,
                    borderColor: Colors.green.shade400,
                  ),
                ],
              ),

              30.verticalSpace,

              // Bonus Tips Section
              _buildSectionCard(
                context: context,
                title: "🔥 Bonus Tips (Fun & Engaging!)",
                titleColor: Colors.orange.shade800,
                gradientColors: [
                  Colors.orange.shade100,
                  Colors.orange.shade300
                ],
                children: [
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Cinnamon Boost",
                    description:
                        "Did you know? Cinnamon may help reduce blood sugar levels! Try adding ½ tsp to your coffee, oatmeal, or yogurt today. ☕🍂",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Vinegar Trick",
                    description:
                        "A tablespoon of apple cider vinegar before meals can reduce sugar spikes. Try mixing it in water before dinner! 🍏🥂",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Eat Protein First",
                    description:
                        "Pro tip: Start your meal with protein (eggs, fish, or chicken) before carbs to stabilize blood sugar levels! 🍳🥩",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Lemon Water Detox 🍋💧",
                    description:
                        "Drinking warm lemon water in the morning can help improve insulin sensitivity and keep you hydrated. Try it before breakfast! 🍋✨",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Green Tea Boost 🍵🔥",
                    description:
                        "Green tea contains antioxidants that help regulate blood sugar levels. Swap your sugary drinks for a soothing cup today! 🍵💚",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Dark Chocolate Delight 🍫✨",
                    description:
                        "Craving sweets? Dark chocolate (70% or higher) is a great alternative that won’t spike your sugar like regular sweets! 🍫✔️",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Add More Magnesium 🌰🥬",
                    description:
                        "Magnesium-rich foods like spinach, pumpkin seeds, and almonds can help regulate blood sugar levels. Add them to your diet today! 🥗🥜",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "The 5-Minute Deep Breathing Trick 🧘‍♂️",
                    description:
                        "Stress raises blood sugar! Take 5 minutes to practice deep breathing – inhale for 4 sec, hold for 4 sec, exhale for 4 sec. Feel the difference! 🌬️💙",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "The Power of Chia Seeds 🌱",
                    description:
                        "Chia seeds are packed with fiber and omega-3s, helping to slow blood sugar spikes. Add them to your smoothies or yogurt today! 🥣💙",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "The 10-Minute Post-Meal Walk 🚶‍♂️",
                    description:
                        "Walking for just 10 minutes after a meal can lower blood sugar levels significantly. Try a short stroll after lunch today! 🚶‍♀️✅",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Snack Smart with Greek Yogurt 🥄",
                    description:
                        "Greek yogurt is high in protein and probiotics, making it a perfect low-sugar snack. Add some nuts or berries for extra flavor! 🍓🥜",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "Stay Hydrated, Stay Healthy 💦",
                    description:
                        "Drinking enough water helps your body flush out excess sugar. Aim for at least 8 glasses a day to keep your blood sugar in check! 🚰✨",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                  _buildTipCard(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange.shade400,
                      size: 24.sp,
                    ),
                    title: "The Magic of Bitter Melon 🍈",
                    description:
                        "Bitter melon has compounds that naturally lower blood sugar! Try it in a smoothie or stir-fry for a healthy boost. 🥗💚",
                    backgroundColor: Colors.orange.shade50,
                    borderColor: Colors.orange.shade400,
                  ),
                ],
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
    required Color titleColor,
    required List<Color> gradientColors,
    required List<Widget> children,
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
            Text(
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
            15.verticalSpace,
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper method to build a tip card
  Widget _buildTipCard({
    required Widget icon, // Changed to Widget to accept Icon widget
    required String title,
    required String description,
    required Color backgroundColor,
    required Color borderColor,
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
              icon, // Use the Icon widget here
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FeedViewModel viewModelBuilder(BuildContext context) => FeedViewModel();
}
