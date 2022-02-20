import 'package:app/helpers/constants.dart';
import 'package:app/models/models.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/pages_barell.dart';
import 'package:flutter/material.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager screenManager;
  final UserManager userManager;

  AppRouter({
    required this.screenManager,
    required this.userManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    screenManager.addListener(notifyListeners);
    userManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    screenManager.removeListener(notifyListeners);
    userManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        OopsScreen.page(),
        // screens go between this
        if (screenManager.activeScreen == TIMELINE_PATH &&
            userManager.userType == UserType.SuperAdmin)
          TimelinePage.page(),

        // and this
        if (screenManager.authRequired && userManager.isLoggedOut)
          LoginPage.page(),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
