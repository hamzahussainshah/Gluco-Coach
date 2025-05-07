import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class LogExerciseViewModel extends BaseViewModel {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? errorMessage;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Select a date using a date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  // Log the exercise to Firestore
  Future<void> logExercise() async {
    setBusy(true);
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        errorMessage = "Please log in to save your exercise.";
        notifyListeners();
        return;
      }

      // Validate inputs
      if (typeController.text.isEmpty || durationController.text.isEmpty) {
        errorMessage = "Please fill in all fields.";
        notifyListeners();
        return;
      }

      int? duration = int.tryParse(durationController.text);
      if (duration == null || duration <= 0) {
        errorMessage = "Please enter a valid duration.";
        notifyListeners();
        return;
      }

      // Prepare data
      String userId = user.uid;
      Map<String, dynamic> exerciseData = {
        'type': typeController.text,
        'duration': duration,
        'date': "${DateTime.now()}",
        'timestamp': DateTime.now(),
      };

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('exercises')
          .add(exerciseData);

      // Clear form after saving
      typeController.clear();
      durationController.clear();
      selectedDate = DateTime.now();
      errorMessage = null;
      setBusy(false);
      // Show success toast
      Fluttertoast.showToast(
        msg: "Exercise logged successfully!",
        toastLength: Toast.LENGTH_LONG, // Duration of the toast
        gravity: ToastGravity.BOTTOM, // Position of the toast
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      _navigationService.back(
        result: true,
      );
      notifyListeners();
    } catch (e) {
      setBusy(false);
      errorMessage = "Failed to log exercise: $e";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    typeController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
