import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:gluco_coach/ui/widgets/snakbar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool obscurePassword = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setBusy(true); // Show loading state
    try {
      UserCredential userCredential =
          await _firebase.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) {
        showErrorSnackBar("Login Failed", "User not found. Please try again.");
        return;
      }

      bool hasAnsweredQuestions = await _checkUserResponses(user.uid);
      debugPrint("Has answered questions: $hasAnsweredQuestions");
      showSuccessSnackBar("Login Successful", "Welcome back!");

      // Navigate based on questionnaire completion
      _navigationService.replaceWith(
        hasAnsweredQuestions ? Routes.dashboardView : Routes.questionariesView,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code}");
      String errorMessage = _getFirebaseAuthErrorMessage(e.code);
      showErrorSnackBar("Login Failed", errorMessage);
    } catch (e) {
      debugPrint("Login Error: $e");
      showErrorSnackBar(
          "Error", "An unexpected error occurred. Please try again.");
    } finally {
      setBusy(false); // Hide loading state
    }
  }

  Future<bool> _checkUserResponses(String userId) async {
    try {
      debugPrint("Checking user responses for userId: $userId");
      DocumentSnapshot doc =
          await _firestore.collection('user_responses').doc(userId).get();

      if (doc.exists) {
        debugPrint("Document exists: ${doc.data()}");
        // Optionally, check if the document has specific fields to confirm completion
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.isNotEmpty) {
          debugPrint("User has completed questionnaire.");
          return true;
        } else {
          debugPrint("Document exists but is empty.");
          return false;
        }
      } else {
        debugPrint("Document does not exist for userId: $userId");
        return false;
      }
    } catch (e) {
      debugPrint('Error checking user responses: $e');
      showErrorSnackBar("Error", "Failed to check questionnaire status: $e");
      return false; // Default to false on error to avoid blocking the user
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(Routes.signupView);
  }

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
      case "invalid-credential":
        return "Invalid credentials. Check your email or password.";
      case "operation-not-allowed":
        return "Email/password login is disabled. Contact support.";
      default:
        return "Login failed due to an unknown error. Please try again.";
    }
  }

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void navigateToForgotPasswordView() {
    _navigationService.navigateTo(Routes.forgotPasswordView);
  }
}
