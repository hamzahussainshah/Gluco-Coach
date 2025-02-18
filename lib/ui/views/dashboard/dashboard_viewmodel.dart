import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gluco_coach/app/app.router.dart';
import 'package:gluco_coach/ui/views/feed/feed_view.dart';
import 'package:gluco_coach/ui/views/today/today_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class DashboardViewModel extends IndexTrackingViewModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService _navigationService = locator<NavigationService>();
  bool isDrawerOpen = false;
  int drawerIndex = 0;
  onDrawerItemTap(int index) {
    isDrawerOpen = true;
    drawerIndex = index;
    scaffoldKey.currentState?.openEndDrawer();
    notifyListeners();
  }

  /// List of Screens for BottomNavigationBar
  final List<Widget> bottomNavScreens = [
    FeedView(), // Screen 0
    TodayView(), // Screen 1
  ];
  final List<String> appBarTitles = [
    "Statistics",
    "Add Sales",
    "My Sales",
    "Create Customer",
  ];

  /// Bottom Navigation Bar Items
  List<BottomNavigationBarItem> getBottomNavBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.feed),
        label: "Feed",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        label: "Today",
      ),
    ];
  }


  void logOut() {
    _navigationService.replaceWithLoginView();
  }
}
