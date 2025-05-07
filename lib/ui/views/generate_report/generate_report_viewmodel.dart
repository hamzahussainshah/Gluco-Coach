import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';

class GenerateReportViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedPeriod = 'Weekly'; // Default period
  List<Map<String, dynamic>> exerciseData = [];
  String? name;

  GenerateReportViewModel() {
    initializeUserData();
  }

  // Initialize user data (name)
  void initializeUserData() {
    User? user = _auth.currentUser;
    if (user != null) {
      name = user.displayName ?? "User";
    } else {
      name = "Guest";
    }
    notifyListeners();
  }

  // Set the period and fetch data
  void setPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

  // Fetch exercise data based on the selected period
  Future<void> fetchExerciseData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("No user logged in");
        exerciseData = [];
        return;
      }

      String userId = user.uid;
      DateTime now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      if (selectedPeriod == 'Weekly') {
        // Weekly: Current week (Monday to current day)
        int daysSinceMonday = (now.weekday + 6) % 7;
        startDate = now.subtract(Duration(days: daysSinceMonday));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else {
        // Monthly: Current month (1st to current day)
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      }

      print("Fetching exercises from $startDate to $endDate for user $userId");

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('exercises')
          .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('timestamp', descending: true)
          .get();

      print("Fetched ${querySnapshot.docs.length} exercises");

      exerciseData = querySnapshot.docs.map((doc) {
        DateTime exerciseDate = (doc['timestamp'] as Timestamp).toDate();
        return {
          'type': doc['type'] as String,
          'duration': doc['duration'] as int,
          'date': exerciseDate,
        };
      }).toList();

      print("Exercise data: $exerciseData");
    } catch (e) {
      print("Error fetching exercise data: $e");
      exerciseData = [];
    }
  }

  // Generate and save the PDF
  Future<void> generateAndSavePDF(BuildContext context) async {
    setBusy(true);
    try {
      // Fetch the exercise data
      await fetchExerciseData();

      if (exerciseData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No exercise data available to generate a report.")),
        );
        setBusy(false);
        return;
      }

      // Create a PDF document
      final pdf = pw.Document();

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Text(
                  "Exercise Report",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "User: $name",
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  "Period: $selectedPeriod (${exerciseData.first['date'].toString().substring(0, 10)} to ${exerciseData.last['date'].toString().substring(0, 10)})",
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),

                // Table of exercise data
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    // Header row
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Date",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Exercise",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Duration (min)",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Data rows
                    ...exerciseData.map((exercise) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              exercise['date'].toString().substring(0, 10),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(exercise['type']),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(exercise['duration'].toString()),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Request storage permission (only if necessary)
      bool hasPermission = true;
      if (Platform.isAndroid) {
        // On Android 13+, we don't need storage permission for getTemporaryDirectory
        final versionString = Platform.version.split('.')[0];
        final version = int.tryParse(versionString) ?? 0; // Safely parse the version
        if (version >= 33) {
          print("Android 13 or above, no storage permission needed for temporary directory.");
        } else {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
            if (!status.isGranted) {
              hasPermission = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Storage permission denied. Cannot save PDF.")),
              );
              setBusy(false);
              return;
            }
          }
        }
      }

      if (!hasPermission) {
        setBusy(false);
        return;
      }

      // Save the PDF to the device
      final directory = await getTemporaryDirectory();
      final file = File("${directory.path}/exercise_report.pdf");
      await file.writeAsBytes(await pdf.save());

      // Show a dialog with options to view or share the PDF
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Report Generated"),
          content: const Text("Your exercise report has been generated. What would you like to do?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                OpenFile.open(file.path);
              },
              child: const Text("View PDF"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Share.shareXFiles([XFile(file.path)],
                    text: "My Exercise Report");
              },
              child: const Text("Share PDF"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error generating PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate PDF: $e")),
      );
    } finally {
      setBusy(false);
    }
  }
}