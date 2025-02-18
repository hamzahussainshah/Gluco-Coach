import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

  Future<void> forgotPassword() async {
    setBusy(true); // Show loading state

    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      showSuccessSnackBar(
        "Success",
        "Password reset email has been sent. Check your inbox.",
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      showErrorSnackBar("Reset Failed", errorMessage);
    } catch (e) {
      showSuccessSnackBar(
        "Error",
        "An unexpected error occurred. Please try again later.",
      );
    } finally {
      setBusy(false);
    }
  }

  // Convert FirebaseAuthException codes into user-friendly messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case "user-not-found":
        return "No account found with this email. Please check and try again.";
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "missing-email":
        return "Please enter your email address.";
      default:
        return "Password reset failed. Please try again.";
    }
  }
}
