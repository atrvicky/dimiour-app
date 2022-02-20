import 'package:flutter/material.dart';

class DimiourTheme {
  static TextTheme lightTextTheme = const TextTheme(
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    caption: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    button: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = const TextTheme(
    headline1: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,  
    ),
    bodyText2: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    caption: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    button: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      errorColor: Colors.red[700],
      disabledColor: Colors.grey[700]!.withOpacity(0.7),
      primaryColor: Colors.blue,
      primaryColorDark: Colors.blue[600],
      splashColor: Colors.blue[200],
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
      checkboxTheme:
          CheckboxThemeData(fillColor: MaterialStateColor.resolveWith((states) {
        return Colors.black;
      })),
      backgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      switchTheme: const SwitchThemeData(
        thumbColor: SwitchColor(),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
        scrimColor: Colors.black.withOpacity(0.8),
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.white,
        contentTextStyle: lightTextTheme.caption,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        labelStyle: lightTextTheme.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      errorColor: Colors.red[700],
      disabledColor: Colors.grey[700]!.withOpacity(0.7),
      primaryColor: Colors.blue,
      splashColor: Colors.blue[200],
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      switchTheme: const SwitchThemeData(
        thumbColor: SwitchColor(),
      ),
      primaryColorDark: Colors.blue[600],
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: Colors.white,
        contentTextStyle: darkTextTheme.caption,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.black,
        scrimColor: Colors.black.withOpacity(0.8),
      ),
      backgroundColor: Colors.black,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        labelStyle: darkTextTheme.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      textTheme: darkTextTheme,
    );
  }
}

class SwitchColor extends MaterialStateColor {
  const SwitchColor() : super(_defaultColor);

  static const int _defaultColor = 0xff4caf50;
  static const int _pressedColor = 0xff43a047;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.toList().contains(MaterialState.pressed) ||
        states.toList().contains(MaterialState.selected)) {
      return const Color(_pressedColor);
    }
    return const Color(_defaultColor);
  }
}
