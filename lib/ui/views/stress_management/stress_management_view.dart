import 'package:flutter/material.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Mindful Breathing Exercises
              _buildSectionTitle(context, "Mindful Breathing Exercises"),
              _buildSectionSubtitle(context, "Reduce Cortisol & Improve Insulin Sensitivity"),
              ...viewModel.breathingExercises.map(
                    (exercise) => _buildListItem(context, exercise),
              ),
              const Divider(height: 30, thickness: 1),

              // Section 2: Meditation & Relaxation Techniques
              _buildSectionTitle(context, "Meditation & Relaxation Techniques"),
              ...viewModel.meditationTechniques.map(
                    (technique) => _buildListItem(context, technique),
              ),
              const Divider(height: 30, thickness: 1),

              // Section 3: Physical Activity for Stress Relief
              _buildSectionTitle(context, "Physical Activity for Stress Relief"),
              ...viewModel.physicalActivities.map(
                    (activity) => _buildListItem(context, activity),
              ),
              const Divider(height: 30, thickness: 1),

              // Section 4: Sleep Hygiene & Relaxation Before Bed
              _buildSectionTitle(context, "Sleep Hygiene & Relaxation Before Bed"),
              ...viewModel.sleepHygieneTips.map(
                    (tip) => _buildListItem(context, tip),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildSectionSubtitle(BuildContext context, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 18, color: Colors.teal)),
          Expanded(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  StressManagementViewModel viewModelBuilder(BuildContext context) =>
      StressManagementViewModel();
}