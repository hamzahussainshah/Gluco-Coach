import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class TodayViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = locator<NavigationService>();
  String? name;
  TodayViewModel() {
    name = _auth.currentUser!.displayName;
  }
  List<FlSpot> getBloodSugarSpots() {
    // Fetch from Firestore or local data
    return [
      FlSpot(0, 120),
      FlSpot(1, 130),
      // ...etc.
    ];
  }

  void navigateToWorkoutPlanView() {
    _navigationService.navigateToWorkoutPlanView();
  }

  void navigateToMealPlanView() {
    _navigationService.navigateToMealPlanView();
  }

  void navigateToStressManagementView() {
    _navigationService.navigateToStressManagementView();
  }
}
