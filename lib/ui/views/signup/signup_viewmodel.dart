import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    setBusy(true); // Show loading state

    try {
      UserCredential userCredential =
          await _firebase.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Update display name
      await userCredential.user
          ?.updateProfile(displayName: nameController.text);
      await userCredential.user?.reload();

      // Show success snackbar
      showSuccessSnackBar(
        'Success',
        "Sign-up successful! Welcome, ${nameController.text}",
      );

      _navigationService.navigateToHomeView(); // Navigate to Home
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth-specific errors
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      showErrorSnackBar(
        'Error',
        errorMessage,
      );
    } catch (e) {
      // Handle any other errors
      showErrorSnackBar(
          "Error", "An unexpected error occurred. Please try again.");
    } finally {
      setBusy(false); // Hide loading state
    }
  }

  void navigateToLogin() {
    _navigationService.navigateToLoginView();
  }

  // Convert FirebaseAuthException codes into user-friendly messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case "email-already-in-use":
        return "This email is already registered. Try logging in.";
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "weak-password":
        return "Your password is too weak. Use at least 6 characters.";
      case "operation-not-allowed":
        return "Email/password signup is not enabled in Firebase.";
      default:
        return "Sign-up failed. Please try again.";
    }
  }
}
