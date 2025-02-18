import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class QuestionariesViewModel extends BaseViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = locator<NavigationService>();

  TextEditingController textEditingController = TextEditingController();

  int currentQuestionIndex = 0;
  String? selectedAnswer;

  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your age?',
      'options': ['Under 18', '18–30', '31–45', '46–60', 'Above 60'],
    },
    {
      'question': 'What is your blood group?',
      'options': [
        'A+',
        'A-',
        'B+',
        'B-',
        'AB+',
        'AB-',
        'O+',
        'O-',
        'Don’t know'
      ],
    },
    {
      'question': 'How long have you been diagnosed with diabetes?',
      'options': [
        'Recently diagnosed (less than 1 year)',
        '1–5 years',
        '5–10 years',
        'More than 10 years'
      ],
    },
    {
      'question': 'What is your average blood pressure level?',
      'options': [
        'Normal (120/80 mmHg or below)',
        'Elevated (120–129/<80 mmHg)',
        'High (130–139/80–89 mmHg or higher)',
        'Don’t know'
      ],
    },
    {
      'question': 'Do you have hypertension (high blood pressure)?',
      'options': ['Yes', 'No'],
    },
    {
      'question':
          'Are you currently using insulin or other medications for diabetes?',
      'options': [
        'Yes, I use insulin.',
        'Yes, I use oral medications (e.g., metformin).',
        'No, I manage my diabetes through diet and exercise.',
        'No, I am not on any treatment yet.'
      ],
    },
    {
      'question':
          'If yes, please specify the type of insulin or medication you use:',
      'isTextField': true,
    },
    {
      'question': 'What type of diabetes do you have?',
      'options': [
        'Type 1 Diabetes',
        'Type 2 Diabetes',
        'Prediabetes',
        'Gestational Diabetes',
        'Don’t know'
      ],
    },
    {
      'question': 'What is your average blood sugar level?',
      'options': [
        'Fasting blood sugar (mg/dL or mmol/L)',
        'Post-meal blood sugar (mg/dL or mmol/L)',
        'HbA1c level (%)'
      ],
    },
    {
      'question': 'How often do you check your blood sugar levels?',
      'options': [
        'Multiple times a day',
        'Once a day',
        'A few times a week',
        'Rarely'
      ],
    },
    {
      'question': 'What is your current weight and height?',
      'options': ['Weight (in kg or lbs)', 'Height (in cm or feet/inches)'],
    },
    {
      'question': 'What is your goal weight (if any)?',
      'isTextField': true,
    },
    {
      'question': 'How would you describe your current activity level?',
      'options': [
        'Sedentary (little to no exercise)',
        'Lightly active (light exercise 1–3 days/week)',
        'Moderately active (moderate exercise 3–5 days/week)',
        'Very active (intense exercise 6–7 days/week)'
      ],
    },
    {
      'question': 'Do you have any dietary preferences or restrictions?',
      'options': [
        'Vegetarian',
        'Vegan',
        'Gluten-free',
        'Low-carb',
        'No restrictions',
        'Other (please specify)'
      ],
    },
    {
      'question': 'If other, please specify your dietary preference:',
      'isTextField': true,
    },
    {
      'question': 'Do you have any food allergies or intolerances?',
      'options': [
        'None',
        'Dairy',
        'Nuts',
        'Shellfish',
        'Other (please specify)'
      ],
    },
    {
      'question': 'Do you smoke or consume alcohol?',
      'options': [
        'Smoker',
        'Non-smoker',
        'Occasional drinker',
        'Regular drinker',
        'Non-drinker'
      ],
    },
    {
      'question': 'How would you rate your stress levels?',
      'options': ['Low', 'Moderate', 'High'],
    },
    {
      'question': 'How many hours of sleep do you get on average per night?',
      'options': [
        'Less than 5 hours',
        '5–6 hours',
        '7–8 hours',
        'More than 8 hours'
      ],
    },
    {
      'question':
          'Is there a family history of diabetes or related conditions (e.g., heart disease, hypertension)?',
      'options': ['Yes', 'No', 'Don’t know'],
    },
    {
      'question':
          'Do you have any other health conditions (e.g., heart disease, kidney disease, PCOS)?',
      'options': ['Yes (please specify)', 'No'],
    },
    {
      'question': 'What are your primary health goals?',
      'options': [
        'Lower blood sugar levels',
        'Lose weight',
        'Improve fitness',
        'Manage stress',
        'Other (please specify)'
      ],
    },
    {
      'question': 'If other, please specify your health goal:',
      'isTextField': true,
    },
  ];

  List<Map<String, String>> answers = [];

  QuestionariesViewModel() {
    textEditingController.addListener(() {
      notifyListeners(); // Refresh UI when text field changes
    });
  }

  /// Save answer and move to the next question
  void saveAnswer(String answer) {
    answers.add({
      'question': questions[currentQuestionIndex]['question'],
      'answer': answer
    });
    selectedAnswer = answer;
    notifyListeners();
  }

  /// Enable Next button only when an answer is selected or text field has text
  bool get isNextButtonEnabled {
    if (questions[currentQuestionIndex].containsKey('isTextField')) {
      return textEditingController.text.isNotEmpty;
    }
    return selectedAnswer != null;
  }

  /// Go to next question
  /// Go to next question
  Future<void> nextQuestion() async {
    setBusy(true);
    if (questions[currentQuestionIndex].containsKey('isTextField')) {
      saveAnswer(textEditingController.text);
      textEditingController.clear();
    }

    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      selectedAnswer = null;
      setBusy(false);
      notifyListeners();
    } else {
      await saveResponsesToFirestore();
      setBusy(false);
    }
  }

  /// Save responses to Firestore
  Future<void> saveResponsesToFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      var response =
          await _firestore.collection('user_responses').doc(user.uid).set({
        'userId': user.uid,
        'responses': answers,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _navigationService.navigateToDashboardView();
    } catch (e) {
      showErrorSnackBar("Error", e.toString());
      print('Error saving responses: $e');
    }
  }

  void updateTextField() {
    if (textEditingController.text.isNotEmpty) {
      selectedAnswer = textEditingController.text;
    } else {
      selectedAnswer = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
