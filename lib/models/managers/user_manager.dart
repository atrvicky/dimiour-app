import 'package:app/helpers/constants.dart';
import 'package:app/helpers/misc_helper.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserManager extends ChangeNotifier {
  User user = User();
  bool darkMode = true;
  bool initialized = false;

  Future<bool> loadUserFromCache(AppStateManager appState) async {
    setinitialized(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user.name = prefs.getString("name") ?? "";
    user.loginState = MiscHelper.getUserStateFromString(
        prefs.getString("isLoggedIn") ?? "UserState.LoggedOut");
    user.userType = MiscHelper.getUserTypeFromString(
        prefs.getString("userType") ?? "UserType.SuperAdmin");
    user.id = prefs.getString("id") ?? "";
    user.accessToken = prefs.getString("accessToken") ?? "";
    darkMode = prefs.getBool("darkMode") ?? false;
    initialized = prefs.getBool("initialized") ?? false;

    if (user.accessToken.isEmpty) {
      appState.updatePage(LOGIN_PATH);
    }
    notifyListeners();
    setinitialized(true);
    return true;
  }

  Future<void> storeUser(User user) async {
    if (user.accessToken.length > 3) {
      user.loginState = UserState.LoggedIn;
    } else {
      user.loginState = UserState.LoggedOut;
    }
    setLoginState(user);
    setName(user);
    setID(user);
    setAccessToken(user);
    setUserType(user);
    return;
  }

  void removeUser() {
    User emptyUser = User();
    user = emptyUser;
    storeUser(user);
  }

  String? get name => user.name;
  UserState? get loginState => user.loginState;
  bool get isLoggedOut => user.loginState != UserState.LoggedIn;
  String? get id => user.id;
  String? get accessToken => 'Bearer ' + user.accessToken;
  UserType? get userType => user.userType;

  void setName(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.name = user.name;
    prefs.setString("name", user.name);

    notifyListeners();
  }

  void setLoginState(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.loginState = user.loginState;
    prefs.setString("isLoggedIn", user.loginState.toString());

    notifyListeners();
  }

  void setID(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.id = user.id;
    prefs.setString("id", user.id);

    notifyListeners();
  }

  void setAccessToken(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.accessToken = user.accessToken;
    prefs.setString("accessToken", user.accessToken);

    notifyListeners();
  }

  void setUserType(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.userType = user.userType;
    prefs.setString("userType", user.userType.toString());

    notifyListeners();
  }

  void logout(AppStateManager screenManager, bool forceOut) {
    removeUser();
    if (forceOut) {
      screenManager.updatePage(LOGIN_PATH);
    }
    notifyListeners();
  }

  void setDarkMode(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.darkMode = darkMode;
    prefs.setBool("darkMode", darkMode);
    notifyListeners();
  }

  bool get isDarkMode => darkMode;

  void setinitialized(bool initialized) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.initialized = initialized;
    prefs.setBool("initialized", initialized);
    notifyListeners();
  }

  bool get isInitialized => initialized;
}
