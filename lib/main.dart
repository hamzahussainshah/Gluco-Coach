import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gluco_coach/app/app.bottomsheets.dart';
import 'package:gluco_coach/app/app.dialogs.dart';
import 'package:gluco_coach/app/app.locator.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await requestPermissions();

  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

Future<void> requestPermissions() async {
  final permissionsToRequest = <Permission>[];

  if (await Permission.storage.isDenied || await Permission.storage.isPermanentlyDenied) {
    permissionsToRequest.add(Permission.storage);
  }

  if (await Permission.photos.isDenied || await Permission.photos.isPermanentlyDenied) {
    permissionsToRequest.add(Permission.photos);
  }

  if (permissionsToRequest.isNotEmpty) {
    Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();

    statuses.forEach((permission, status) async {
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    });
  }
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
            ),
          ),
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
        ),
      ),
    );
  }
}
