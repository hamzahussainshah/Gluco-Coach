import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../services/local_storage_service.dart';
import '../../common/exercise.dart';

class WorkoutPlanViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _localStorageService =
  locator<LocalStorageService>();
  List<Map<String, dynamic>> allExercises = [];
  Map<String, dynamic>? currentExercise;
  int currentExerciseIndex = 0;
  DateTime? lastUpdatedDate;
  DateTime? signupDate;

  // Checkbox state
  bool _isExerciseCompleted = false;
  bool get isExerciseCompleted => _isExerciseCompleted;

  // Replace with your YouTube Data API key
  final String apiKey = 'AIzaSyAne1hGwsXzO2U8gjTUFF-BrWbrZDmjkfY';

  // Simulated exercise log (you can replace this with actual logged data)
  List<Map<String, dynamic>> exerciseLog = [];

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WorkoutPlanViewModel() {
    // Ensure LocalStorageService is initialized
    _localStorageService.init();
  }

  Future<void> fetchUserWorkoutPlan() async {
    setBusy(true);
    try {
      await _loadPersistedData();
      await _fetchSignupDate();
      await _fetchExercises();
      _setDailyExercise();
      _generateExerciseLog();
      // Check if the current exercise is already logged for today
      await _checkIfExerciseLogged();
    } catch (e) {
      print('Error fetching workout plan: $e');
      _setDailyExerciseWithoutPersistence();
      _generateExerciseLog();
      setExerciseCompleted(false);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _fetchSignupDate() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      signupDate = DateTime.now();
      return;
    }

    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('signupDate')) {
          signupDate = DateTime.parse(userData['signupDate']);
          print('Signup date fetched: $signupDate');
        } else {
          signupDate = DateTime.now();
          await _firestore.collection('users').doc(user.uid).set({
            'signupDate': signupDate!.toIso8601String(),
          }, SetOptions(merge: true));
          print('Signup date not found, set to: $signupDate');
        }
      } else {
        signupDate = DateTime.now();
        await _firestore.collection('users').doc(user.uid).set({
          'signupDate': signupDate!.toIso8601String(),
        }, SetOptions(merge: true));
        print('User document not found, set signup date to: $signupDate');
      }
    } catch (e) {
      print('Error fetching signup date: $e');
      signupDate = DateTime.now();
    }
  }

  Future<void> _checkIfExerciseLogged() async {
    if (currentExercise == null || currentExercise!['name'] == 'No Exercise') {
      setExerciseCompleted(false);
      return;
    }

    DateTime? lastLogDate = _localStorageService.lastExerciseLogDate;
    if (lastLogDate != null) {
      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime lastLogDay =
      DateTime(lastLogDate.year, lastLogDate.month, lastLogDate.day);

      if (lastLogDay.isAtSameMomentAs(todayStart) ||
          lastLogDay.isAfter(todayStart)) {
        setExerciseCompleted(true);
        print('Exercise already logged today according to local storage.');
        return;
      }
    }

    User? user = _auth.currentUser;
    if (user == null) {
      setExerciseCompleted(false);
      return;
    }

    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(const Duration(days: 1));

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('exercises')
          .where('type', isEqualTo: currentExercise!['name'])
          .where('timestamp',
          isGreaterThanOrEqualTo: todayStart, isLessThan: todayEnd)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setExerciseCompleted(true);
        _localStorageService.lastExerciseLogDate = DateTime.now();
      } else {
        setExerciseCompleted(false);
      }
    } catch (e) {
      print('Error checking logged exercise: $e');
      setExerciseCompleted(false);
    }
  }

  Future<void> _fetchExercises() async {
    allExercises = ExerciseData.getExercises();

    for (var exercise in allExercises) {
      if (exercise.containsKey('videoUrls')) {
        List<String> videoUrls = exercise['videoUrls'];
        List<Map<String, String>> videos = [];
        for (var url in videoUrls) {
          String videoId = _extractVideoId(url);
          String? title = await _fetchVideoTitle(videoId);
          videos.add({
            'url': url,
            'thumbnail': 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            'title': title ?? 'Workout Video',
          });
        }
        exercise['videos'] = videos;
      }
    }

    print('Fetched exercises: $allExercises');
  }

  void _generateExerciseLog() {
    exerciseLog = allExercises
        .where((exercise) => !exercise.containsKey('week'))
        .map((exercise) {
      return {
        'name': exercise['name'],
        'duration': exercise['duration'],
        'description': exercise['description'],
        'date': DateTime.now()
            .subtract(Duration(days: allExercises.indexOf(exercise))),
      };
    }).toList();

    notifyListeners();
  }

  String _extractVideoId(String url) {
    if (url.contains('youtube.com/shorts/')) {
      return url.split('youtube.com/shorts/')[1].split('?')[0];
    } else if (url.contains('watch?v=')) {
      return url.split('watch?v=')[1].split('&')[0];
    }
    return '';
  }

  Future<String?> _fetchVideoTitle(String videoId) async {
    if (videoId.isEmpty) return null;

    final String url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          return data['items'][0]['snippet']['title'];
        } else {
          print('No video found for ID: $videoId');
          return null;
        }
      } else {
        print('Failed to fetch video title: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching video title: $e');
      return null;
    }
  }

  Future<void> _loadPersistedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? lastUpdatedDateString = prefs.getString('lastUpdatedDate');
      currentExerciseIndex = prefs.getInt('currentExerciseIndex') ?? 0;

      if (lastUpdatedDateString != null) {
        lastUpdatedDate = DateTime.parse(lastUpdatedDateString);
      } else {
        lastUpdatedDate = null;
      }

      print(
          'Loaded data: lastUpdatedDate=$lastUpdatedDate, currentExerciseIndex=$currentExerciseIndex');
    } catch (e) {
      print('Error loading SharedPreferences: $e');
      lastUpdatedDate = null;
      currentExerciseIndex = 0;
    }
  }

  Future<void> _saveCurrentState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentExerciseIndex', currentExerciseIndex);
      await prefs.setString(
          'lastUpdatedDate', DateTime.now().toIso8601String());
      print(
          'Saved state: currentExerciseIndex=$currentExerciseIndex, lastUpdatedDate=${DateTime.now()}');
    } catch (e) {
      print('Error saving to SharedPreferences: $e');
    }
  }

  Future<void> _resetSignupDate() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('No user logged in, cannot reset signup date');
      return;
    }

    try {
      signupDate = DateTime.now();
      await _firestore.collection('users').doc(user.uid).set({
        'signupDate': signupDate!.toIso8601String(),
      }, SetOptions(merge: true));
      print('Signup date reset to: $signupDate');

      // Optionally save to SharedPreferences if using local storage fallback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('signupDate', signupDate!.toIso8601String());
    } catch (e) {
      print('Error resetting signup date: $e');
    }
  }

  void _setDailyExercise() {
    List<Map<String, dynamic>> dailyExercises = allExercises
        .where((exercise) => !exercise.containsKey('week'))
        .toList();

    if (dailyExercises.isEmpty) {
      print('No exercises found.');
      currentExercise = {
        'name': 'No Exercise',
        'duration': '',
        'description': 'No exercises available.',
      };
      notifyListeners();
      return;
    }

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (signupDate == null) {
      signupDate = today;
      print('Signup date not set, defaulting to today: $signupDate');
    }

    DateTime signupDay =
    DateTime(signupDate!.year, signupDate!.month, signupDate!.day);
    int daysSinceSignup = today.difference(signupDay).inDays;

    if (daysSinceSignup < 0) {
      daysSinceSignup = 0;
      print('Days since signup is negative, setting to 0');
    }

    // Calculate the current exercise index
    currentExerciseIndex = daysSinceSignup % dailyExercises.length;
    print('Days since signup: $daysSinceSignup, Initial exercise index: $currentExerciseIndex');

    // Check if the user is on the last exercise
    if (currentExerciseIndex == dailyExercises.length - 1) {
      // Reset the exercise counter by updating the signup date to today
      _resetSignupDate();
      signupDate = today; // Update the local signupDate
      daysSinceSignup = 0; // Reset days since signup
      currentExerciseIndex = 0; // Start from the first exercise
      print('Reached the last exercise, resetting to index 0');
    }

    // Update lastUpdatedDate to today
    lastUpdatedDate = today;
    _saveCurrentState();

    currentExercise = dailyExercises[currentExerciseIndex];
    print('Selected exercise: ${currentExercise!['name']}');
    notifyListeners();
  }

  void _setDailyExerciseWithoutPersistence() {
    List<Map<String, dynamic>> dailyExercises = allExercises
        .where((exercise) => !exercise.containsKey('week'))
        .toList();

    if (dailyExercises.isEmpty) {
      currentExercise = {
        'name': 'No Exercise',
        'duration': '',
        'description': 'No exercises available.',
      };
    } else {
      currentExerciseIndex = 0;
      currentExercise = dailyExercises[currentExerciseIndex];
      print('Fallback selected exercise: ${currentExercise!['name']}');
    }
    notifyListeners();
  }

  Future<void> launchVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  void setExerciseCompleted(bool value) {
    _isExerciseCompleted = value;
    notifyListeners();
  }

  Future<void> logExercise(int durationInMinutes) async {
    setBusy(true);
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: "Please log in to save your exercise.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setExerciseCompleted(false);
        setBusy(false);
        return;
      }

      if (currentExercise == null ||
          currentExercise!['name'] == 'No Exercise') {
        Fluttertoast.showToast(
          msg: "No valid exercise to log.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setExerciseCompleted(false);
        setBusy(false);
        return;
      }

      String userId = user.uid;
      DateTime now = DateTime.now();
      Map<String, dynamic> exerciseData = {
        'type': currentExercise!['name'],
        'duration': durationInMinutes,
        'date': now.toIso8601String(),
        'timestamp': now,
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('exercises')
          .add(exerciseData);

      _localStorageService.lastExerciseLogDate = now;

      Fluttertoast.showToast(
        msg: "Exercise logged successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setExerciseCompleted(true);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to log exercise: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setExerciseCompleted(false);
    } finally {
      setBusy(false);
    }
  }

  void back() {
    _navigationService.back(
      result: true,
    );
  }
}