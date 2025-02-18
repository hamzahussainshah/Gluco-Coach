import 'package:flutter/material.dart';
import 'package:gluco_coach/ui/widgets/custom_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import 'questionaries_viewmodel.dart';

class QuestionariesView extends StackedView<QuestionariesViewModel> {
  const QuestionariesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    QuestionariesViewModel viewModel,
    Widget? child,
  ) {
    return ModalProgressHUD(
        color: Colors.black54,
        opacity: 1,
        progressIndicator: LoadingAnimationWidget.newtonCradle(
          color: Colors.blueAccent,
          size: 50,
        ),
        inAsyncCall: viewModel.isBusy,
        child: Scaffold(
          backgroundColor: AppColors.gray100,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressIndicator(viewModel),
                    const SizedBox(height: 20),
                    _buildQuestion(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  /// Progress Indicator
  Widget _buildProgressIndicator(QuestionariesViewModel viewModel) {
    return LinearProgressIndicator(
      value: viewModel.currentQuestionIndex / viewModel.questions.length,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation(AppColors.red600),
    );
  }

  /// Display Question & Options
  Widget _buildQuestion(QuestionariesViewModel viewModel) {
    final currentQuestion = viewModel.questions[viewModel.currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentQuestion['question'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        if (currentQuestion.containsKey('options'))
          ...currentQuestion['options'].map<Widget>((option) {
            return _buildOptionTile(viewModel, option);
          }).toList(),
        if (currentQuestion.containsKey('isTextField'))
          _buildTextField(viewModel),
        const SizedBox(height: 20),
        _buildNextButton(viewModel),
      ],
    );
  }

  /// Multiple Choice Options
  Widget _buildOptionTile(QuestionariesViewModel viewModel, String option) {
    bool isSelected = viewModel.selectedAnswer == option;

    return GestureDetector(
      onTap: () => viewModel.saveAnswer(option),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        color: isSelected
            ? AppColors.red300
            : Colors.white, // Change background color when selected
        child: ListTile(
          title: Text(option,
              style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black)),
          trailing: isSelected
              ? Icon(Icons.check_circle,
                  color: Colors.white) // White icon for contrast
              : Icon(Icons.circle_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  /// Open Text Field for Answers
  Widget _buildTextField(QuestionariesViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.textEditingController,
      onChanged: (value) {
        viewModel.updateTextField();
      },
      hintText: "Enter your answer...",
    );
  }

  /// Next Button
  Widget _buildNextButton(QuestionariesViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.isNextButtonEnabled ? viewModel.nextQuestion : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red500,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child:
            Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  @override
  QuestionariesViewModel viewModelBuilder(BuildContext context) =>
      QuestionariesViewModel();
}
