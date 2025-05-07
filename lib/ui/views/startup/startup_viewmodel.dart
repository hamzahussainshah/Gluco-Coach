import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 4));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
    if (_auth.currentUser != null) {
      // User is logged in, navigate to the main app
      _navigationService.replaceWithDashboardView();
    } else {
      // User is not logged in, navigate to the login view
      _navigationService.replaceWithLoginView();
    }
  }
}
