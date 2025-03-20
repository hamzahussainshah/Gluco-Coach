// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:stacked/stacked.dart';
//
// class WorkoutPlanViewModel extends BaseViewModel {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String? activityLevel;
//   List<Map<String, String>> exercises = [];
//
//   Future<void> fetchUserWorkoutPlan() async {
//     setBusy(true);
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) {
//         activityLevel = null;
//         exercises = [];
//         notifyListeners();
//         return;
//       }
//
//       // Fetch user responses from Firestore
//       DocumentSnapshot doc =
//           await _firestore.collection('user_responses').doc(user.uid).get();
//       if (!doc.exists) {
//         activityLevel = null;
//         exercises = [];
//         notifyListeners();
//         return;
//       }
//
//       // Extract responses
//       List<dynamic> responses = doc['responses'] as List<dynamic>;
//       Map<String, String> answers = {
//         for (var response in responses) response['question']: response['answer']
//       };
//
//       // Get activity level
//       activityLevel =
//           answers['How would you describe your current activity level?'];
//       if (activityLevel != null) {
//         _generateWorkoutPlan(activityLevel!);
//       }
//     } catch (e) {
//       print('Error fetching workout plan: $e');
//       activityLevel = null;
//       exercises = [];
//     } finally {
//       setBusy(false);
//     }
//   }
//
//   void _generateWorkoutPlan(String activityLevel) {
//     // Define workout plans based on activity level
//     switch (activityLevel) {
//       case 'Sedentary (little to no exercise)':
//         exercises = [
//           {'name': 'Walking', 'duration': '15 min', 'reps': 'Daily'},
//           {'name': 'Stretching', 'duration': '10 min', 'reps': '3 sets'},
//           {'name': 'Chair Squats', 'duration': '5 min', 'reps': '10 reps x 2'},
//         ];
//         break;
//       case 'Lightly active (light exercise 1–3 days/week)':
//         exercises = [
//           {'name': 'Brisk Walking', 'duration': '20 min', 'reps': '3x/week'},
//           {
//             'name': 'Bodyweight Squats',
//             'duration': '10 min',
//             'reps': '15 reps x 3'
//           },
//           {'name': 'Arm Circles', 'duration': '5 min', 'reps': '2 sets'},
//         ];
//         break;
//       case 'Moderately active (moderate exercise 3–5 days/week)':
//         exercises = [
//           {'name': 'Jogging', 'duration': '30 min', 'reps': '4x/week'},
//           {'name': 'Push-Ups', 'duration': '10 min', 'reps': '20 reps x 3'},
//           {'name': 'Plank', 'duration': '1 min', 'reps': '3 sets'},
//         ];
//         break;
//       case 'Very active (intense exercise 6–7 days/week)':
//         exercises = [
//           {'name': 'Running', 'duration': '45 min', 'reps': '5x/week'},
//           {'name': 'Burpees', 'duration': '15 min', 'reps': '15 reps x 4'},
//           {'name': 'Mountain Climbers', 'duration': '10 min', 'reps': '3 sets'},
//         ];
//         break;
//       default:
//         exercises = [];
//     }
//     notifyListeners();
//   }
// }

import 'package:stacked/stacked.dart';

class WorkoutPlanViewModel extends BaseViewModel {
  String? activityLevel;
  List<Map<String, String>> exercises = [];

  Future<void> fetchUserWorkoutPlan() async {
    setBusy(true);
    try {
      _generateWorkoutPlan();
    } catch (e) {
      print('Error fetching workout plan: $e');
      exercises = [];
    } finally {
      setBusy(false);
    }
  }

  void _generateWorkoutPlan() {
    exercises = [
      {
        'week': 'Week 1: Aerobic Exercises (Boost Insulin Sensitivity)',
        'name': 'Brisk Walking',
        'duration': '30–45 min',
        'description': 'Improves glucose metabolism and insulin function'
      },
      {
        'name': 'Cycling',
        'duration': '20–40 min',
        'description': 'Lowers blood sugar levels and enhances heart health'
      },
      {
        'name': 'Swimming',
        'duration': '30 min',
        'description': 'Gentle on joints while improving insulin function'
      },
      {
        'name': 'Jump Rope',
        'duration': '10–20 min',
        'description': 'High-intensity for better glucose utilization'
      },
      {
        'name': 'Dancing/Zumba',
        'duration': '30 min',
        'description': 'Fun and effective for lowering blood sugar'
      },
      {
        'week':
            'Week 2: Strength Training (Muscle Improves Glucose Absorption)',
        'name': 'Bodyweight Squats',
        'duration': '3 sets x 12 reps',
        'description': 'Activates large muscles, aiding glucose uptake'
      },
      {
        'name': 'Push-Ups',
        'duration': '3 sets x 10 reps',
        'description': 'Increases upper-body strength and metabolism'
      },
      {
        'name': 'Resistance Band Rows',
        'duration': '3 sets x 12 reps',
        'description': 'Strengthens back and improves insulin sensitivity'
      },
      {
        'name': 'Lunges',
        'duration': '3 sets x 10 reps per leg',
        'description': 'Builds lower-body strength and endurance'
      },
      {
        'name': 'Plank with Shoulder Taps',
        'duration': '3 sets x 30 sec',
        'description': 'Core stability helps regulate metabolism'
      },
      {
        'week':
            'Week 3: Flexibility & Stress Reduction (Lower Cortisol, Improve Insulin)',
        'name': 'Yoga Poses',
        'duration': '15–20 min',
        'description': 'Reduces stress hormones affecting blood sugar'
      },
      {
        'name': 'Deep Breathing',
        'duration': '5 min',
        'description': 'Lowers blood pressure and cortisol levels'
      },
      {
        'name': 'Tai Chi',
        'duration': '15 min',
        'description': 'Enhances insulin regulation and balance'
      },
      {
        'name': 'Foam Rolling',
        'duration': '10 min',
        'description': 'Reduces muscle stiffness, improving movement efficiency'
      },
      {
        'name': 'Guided Meditation',
        'duration': '10 min',
        'description': 'Lowers stress-induced blood sugar spikes'
      },
      {
        'week': 'Week 4: High-Impact Exercises for Diabetes Control',
        'name': 'Jumping Jacks',
        'duration': '3 sets x 30 sec',
        'description':
            'Full-body aerobic movement that enhances insulin efficiency'
      },
      {
        'name': 'Leg Raises',
        'duration': '3 sets x 12 reps',
        'description':
            'Strengthens core muscles and improves glucose metabolism'
      },
      {
        'name': 'Seated Marching',
        'duration': '3 sets x 20 reps',
        'description':
            'Ideal for elderly diabetics to keep blood sugar in check'
      },
      {
        'name': 'Wall Sits',
        'duration': '3 sets x 30 sec',
        'description':
            'Engages lower body muscles to improve glucose utilization'
      },
      {
        'name': 'Battle Ropes (If Available)',
        'duration': '3 sets x 20 sec',
        'description': 'HIIT workout to improve insulin sensitivity'
      },
    ];

    notifyListeners();
  }
}
