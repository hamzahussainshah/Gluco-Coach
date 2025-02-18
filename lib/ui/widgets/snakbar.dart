import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showErrorSnackBar(String title, String message) async {
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    // colorText: AppColors.whiteColor,
    backgroundColor: Colors.red,
    margin: const EdgeInsets.all(16),
  );
  await Future.delayed(5.milliseconds);
}

Future<void> showSuccessSnackBar(String title, String message) async {
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    // colorText: AppColors.whiteColor,
    backgroundColor: Colors.green,
    margin: const EdgeInsets.all(16),
  );
  await Future.delayed(5.milliseconds);
}
