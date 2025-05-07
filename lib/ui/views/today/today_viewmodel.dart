import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

class TodayViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NavigationService _navigationService = locator<NavigationService>();
  String? name;
  String? email;
  List<FlSpot> exerciseSpots = []; // To store chart data
  double maxDuration = 60.0; // Default max duration for the chart
  String selectedFilter = 'Weekly'; // Default filter

  TodayViewModel() {
    initializeUserData();
    fetchExerciseData(); // Fetch data when the view model is created
  }

  // Initialize user data (name and email)
  void initializeUserData() {
    User? user = _auth.currentUser;
    if (user != null) {
      name = user.displayName ??
          "User"; // Fallback to "User" if displayName is null
      email = user.email ?? "No email available";
      print("User data initialized: name=$name, email=$email");
    } else {
      name = "Guest";
      email = "Not logged in";
      print(
          "No user logged in, using default values: name=$name, email=$email");
    }
    notifyListeners();
  }

  // Get the first letter of the username (capitalized)
  String getFirstLetter() {
    if (name == null || name!.isEmpty)
      return "U"; // Default to "U" if name is null or empty
    return name![0].toUpperCase();
  }

  // Set the filter and refresh the data
  void setFilter(String filter) {
    selectedFilter = filter;
    fetchExerciseData(); // Refresh the chart data based on the new filter
  }

  // Fetch exercise data from Firestore based on the selected filter
  Future<void> fetchExerciseData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("No user logged in");
        exerciseSpots = [];
        notifyListeners();
        return;
      }

      String userId = user.uid;
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      if (selectedFilter == 'Weekly') {
        // Weekly: Current week (Monday to current day)
        int daysSinceMonday =
            (now.weekday + 6) % 7; // 0 for Monday, 6 for Sunday
        startDate = now.subtract(Duration(days: daysSinceMonday));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

        print("Weekly filter: Fetching exercises from $startDate to $endDate");

        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('exercises')
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .orderBy('timestamp', descending: true)
            .get();

        print("Fetched ${querySnapshot.docs.length} exercises");

        // Map to store the latest exercise duration per day (Mon-Sun)
        Map<int, double> latestDurations = {for (var i = 0; i < 7; i++) i: 0.0};
        Map<int, Timestamp> latestTimestamps = {
          for (var i = 0; i < 7; i++) i: Timestamp.fromDate(DateTime(1970))
        };

        for (var doc in querySnapshot.docs) {
          DateTime exerciseDate = (doc['timestamp'] as Timestamp).toDate();
          int duration = doc['duration'] as int;
          Timestamp timestamp = doc['timestamp'] as Timestamp;

          // Calculate the day index (0 for Monday, 6 for Sunday)
          int dayIndex = (exerciseDate.weekday + 6) % 7;

          // Update if this is the latest exercise for the day
          if (timestamp.millisecondsSinceEpoch >
              latestTimestamps[dayIndex]!.millisecondsSinceEpoch) {
            latestDurations[dayIndex] = duration.toDouble();
            latestTimestamps[dayIndex] = timestamp;
            print(
                "Updated latest duration for day $dayIndex: ${latestDurations[dayIndex]} minutes");
          }
        }

        // Set future days to 0 (e.g., if today is Friday, Sat and Sun should be 0)
        int currentDayIndex = (now.weekday + 6) % 7;
        for (int i = currentDayIndex + 1; i < 7; i++) {
          latestDurations[i] = 0.0;
        }

        // Convert to FlSpot for the chart
        exerciseSpots = List.generate(7, (index) {
          return FlSpot(index.toDouble(), latestDurations[index]!);
        });

        print(
            "Weekly exerciseSpots: ${exerciseSpots.map((spot) => '(${spot.x}, ${spot.y})').toList()}");

        // Calculate the maximum duration for dynamic y-axis scaling
        maxDuration =
            latestDurations.values.reduce((a, b) => a > b ? a : b).toDouble() +
                10;
        if (maxDuration < 60) maxDuration = 60;

        print("Calculated maxDuration for weekly: $maxDuration");
      } else {
        // Monthly: Current month (1st to current day)
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

        print("Monthly filter: Fetching exercises from $startDate to $endDate");

        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('exercises')
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate))
            .orderBy('timestamp', descending: true)
            .get();

        print("Fetched ${querySnapshot.docs.length} exercises");

        // Aggregate data by week (assuming 4-5 weeks in a month)
        List<double> weeklyDurations = List.filled(5, 0.0); // Max 5 weeks
        int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        int currentDay = now.day;

        for (var doc in querySnapshot.docs) {
          DateTime exerciseDate = (doc['timestamp'] as Timestamp).toDate();
          int duration = doc['duration'] as int;

          // Calculate the week index (0 for first week, 4 for fifth week if applicable)
          int dayOfMonth = exerciseDate.day;
          int weekIndex = (dayOfMonth - 1) ~/ 7;

          weeklyDurations[weekIndex] += duration.toDouble();
        }

        // Only include weeks up to the current day
        int weeksToShow = (currentDay - 1) ~/ 7 + 1;
        exerciseSpots = List.generate(weeksToShow, (index) {
          return FlSpot(index.toDouble(), weeklyDurations[index]);
        });

        print(
            "Monthly exerciseSpots: ${exerciseSpots.map((spot) => '(${spot.x}, ${spot.y})').toList()}");

        // Calculate the maximum duration for dynamic y-axis scaling
        maxDuration =
            weeklyDurations.reduce((a, b) => a > b ? a : b).toDouble() + 10;
        if (maxDuration < 60) maxDuration = 60;

        print("Calculated maxDuration for monthly: $maxDuration");
      }

      notifyListeners(); // Update the UI with the new chart data
    } catch (e) {
      print("Error fetching exercise data: $e");
      exerciseSpots = [];
      notifyListeners();
    }
  }

  void navigateToWorkoutPlanView() {
    _navigationService.navigateToWorkoutPlanView().then((value) {
      if (value == true) {
        fetchExerciseData(); // Refresh data after navigating back
      }
    });
  }

  void navigateToMealPlanView() {
    _navigationService.navigateToMealPlanView();
  }

  void navigateToStressManagementView() {
    _navigationService.navigateToStressManagementView();
  }

  void navigateToLogExerciseView() {
    _navigationService.navigateToLogExerciseView().then(
      (value) {
        if (value == true) {
          fetchExerciseData(); // Refresh data after logging exercise
        }
      },
    );
  }

  void navigateToGenerateReport() {
    _navigationService.navigateToGenerateReportView();
  }
}
