import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile & Greeting Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Good Morning, (User)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Graph & Stats Section (Placeholder for now)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(child: Text("Graph Placeholder")), // Replace with actual graph widget
              ),
              const SizedBox(height: 20),

              // Workout & Meal Plan Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(
                    title: "Workout Plan",
                    color: Colors.blue,
                    icon: Icons.fitness_center,
                  ),
                  _buildCategoryCard(
                    title: "Diet & Meal Plan",
                    color: Colors.red,
                    icon: Icons.restaurant,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Additional Services
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildServiceCard("Tuesel Trends"),
                  _buildServiceCard("Guided Meditation"),
                ],
              ),
            ],
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
  }) {
    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Function to create small service cards
  Widget _buildServiceCard(String title) {
    return Expanded(
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  TodayViewModel viewModelBuilder(BuildContext context) => TodayViewModel();
}
