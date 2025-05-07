import 'package:gluco_coach/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:gluco_coach/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:gluco_coach/ui/views/home/home_view.dart';
import 'package:gluco_coach/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:gluco_coach/ui/views/login/login_view.dart';
import 'package:gluco_coach/ui/views/signup/signup_view.dart';
import 'package:gluco_coach/ui/views/forgot_password/forgot_password_view.dart';
import 'package:gluco_coach/ui/views/questionaries/questionaries_view.dart';
import 'package:gluco_coach/ui/views/dashboard/dashboard_view.dart';
import 'package:gluco_coach/ui/views/today/today_view.dart';
import 'package:gluco_coach/ui/views/feed/feed_view.dart';
import 'package:gluco_coach/ui/views/workout_plan/workout_plan_view.dart';
import 'package:gluco_coach/ui/views/meal_plan/meal_plan_view.dart';
import 'package:gluco_coach/ui/views/stress_management/stress_management_view.dart';
import 'package:gluco_coach/ui/views/log_exercise/log_exercise_view.dart';
import 'package:gluco_coach/services/local_storage_service.dart';
import 'package:gluco_coach/ui/views/generate_report/generate_report_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: ForgotPasswordView),
    MaterialRoute(page: QuestionariesView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: TodayView),
    MaterialRoute(page: FeedView),
    MaterialRoute(page: WorkoutPlanView),
    MaterialRoute(page: MealPlanView),
    MaterialRoute(page: StressManagementView),
    MaterialRoute(page: LogExerciseView),
    MaterialRoute(page: GenerateReportView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: LocalStorageService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
