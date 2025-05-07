import 'package:flutter/material.dart';
import 'package:gluco_coach/ui/widgets/custom_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/custom_elevated_button.dart';
import 'log_exercise_viewmodel.dart';

class LogExerciseView extends StackedView<LogExerciseViewModel> {
  const LogExerciseView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LogExerciseViewModel viewModel,
    Widget? child,
  ) {
    return ModalProgressHUD(
      color: Colors.black54,
      opacity: 1,
      progressIndicator: LoadingAnimationWidget.discreteCircle(
        color: Colors.blueAccent,
        size: 50,
      ),
      inAsyncCall: viewModel.isBusy,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Log Exercise"),
          backgroundColor: Colors.teal,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Type
                  const Text(
                    "Exercise Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "e.g., Running, Yoga",
                    controller: viewModel.typeController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the exercise type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  const Text(
                    "Duration (minutes)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: "e.g., 30",
                    controller: viewModel.durationController,
                    keyboardType: TextInputType.number,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Error Message
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  CustomElevatedButton(
                    text: 'Log Exercise',
                    onPressed: () {
                      if (viewModel.formKey.currentState!.validate()) {
                        viewModel.logExercise();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LogExerciseViewModel viewModelBuilder(BuildContext context) =>
      LogExerciseViewModel();
}
