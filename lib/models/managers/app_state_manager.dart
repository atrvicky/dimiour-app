import 'package:app/helpers/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  String _activeScreen = TIMELINE_PATH;
  int _activeBottomNavIndex = 0;
  NetworkState _networkState = NetworkState.Idle;

  FirebaseMessaging? messaging;

// these screens do not require the user to be authenticated
  final commonScreens = [];

  final screensWithoutNavbar = [
    LOGIN_PATH,
  ];

  int get activeIndex => _activeScreen == TIMELINE_PATH ? 0 : 1;
  bool get authRequired => !commonScreens.contains(_activeScreen);
  String get activeScreen => _activeScreen;
  int get activeScreenIndex => _activeBottomNavIndex;
  bool get showNavBar => !screensWithoutNavbar.contains(_activeScreen);
  NetworkState get networkState => _networkState;
  bool get isNetworkLoading => _networkState == NetworkState.Loading;
  bool get isNetworkIdle => _networkState == NetworkState.Idle;
  bool get isNetworkError => _networkState == NetworkState.Error;

  void updatePage(String newPagePath) {
    _activeScreen = newPagePath;
    notifyListeners();
  }

  void gotoScreen(int index, BuildContext context) {
    _activeBottomNavIndex = index;
    if (index == 1) {
      _activeScreen = SETTINGS_PATH;
    } else {
      _activeScreen = TIMELINE_PATH;
    }
    notifyListeners();
  }

  void displaySnackbar(
      {required BuildContext context,
      required String message,
      ToastType type = ToastType.Success}) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(
            seconds: 5,
          ),
          content: Text(message),
          backgroundColor: type == ToastType.Error
              ? Theme.of(context).errorColor
              : type == ToastType.Success
                  ? Colors.green
                  : Colors.orange[800],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error displaying snackbar.' + e.toString());
      }
    }
  }

  void setNetworkState(NetworkState newState) {
    if (_networkState != newState) {
      _networkState = newState;
      notifyListeners();
    }
  }

  void refresh() {
    notifyListeners();
  }
}
