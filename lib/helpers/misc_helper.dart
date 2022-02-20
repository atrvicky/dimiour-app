import 'package:app/helpers/constants.dart';
import 'package:intl/intl.dart';


class MiscHelper {
  static double lastSetBagSliderValue = 1000;

  static UserType getUserTypeFromString(String userTypeString) {
    switch (userTypeString) {
      case "UserType.Admin":
        return UserType.Admin;
      case "UserType.SuperAdmin":
        return UserType.SuperAdmin;
      default:
        return UserType.User;
    }
  }

  static UserState getUserStateFromString(String userStateString) {
    switch (userStateString) {
      case "UserState.LoggedIn":
        return UserState.LoggedIn;
      case "UserState.LoggedOut":
        return UserState.LoggedOut;
      default:
        return UserState.LoggedOut;
    }
  }

  /// Returns the local date for a given UTC date
  static String getLocalDate(String date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(DateTime.parse(date).toLocal());
    return formatted;
  }

  /// Returns whether the passed number is a double value or not.
  static bool isNumeric({required String s}) {
    return double.tryParse(s) != null;
  }
}
