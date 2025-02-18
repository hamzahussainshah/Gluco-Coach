import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> login() async {
    setBusy(true); // Show loading state

    try {
      await _firebase.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Show success message
      showSuccessSnackBar("Login Successful", "Welcome back!");

      _navigationService.navigateToQuestionariesView();
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth-specific errors
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      showErrorSnackBar("Login Failed", errorMessage);
    } catch (e) {
      // Handle any other errors
      showErrorSnackBar(
          "Error", "An unexpected error occurred. Please try again.");
    } finally {
      setBusy(false); // Hide loading state
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateToSignupView();
  }

  // Convert FirebaseAuthException codes into user-friendly messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case "user-not-found":
        return "No account found with this email. Please sign up first.";
      case "wrong-password":
        return "Incorrect password. Please try again.";
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "user-disabled":
        return "This account has been disabled. Contact support.";
      case "too-many-requests":
        return "Too many login attempts. Please try again later.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
