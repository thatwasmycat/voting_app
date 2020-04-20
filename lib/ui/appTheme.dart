import 'package:flutter/material.dart';


var lightAppColors = LightThemeColors();
var darkAppColors = DarkThemeColors();


class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffF3F3F3),
    appBarTheme: AppBarTheme(
      color: Color(0xffF3F3F3),
      iconTheme: IconThemeData(
        color: lightAppColors.text,
      ),
    ),
    backgroundColor: Color(0xffFFFFFF),
    colorScheme: ColorScheme.light(
      primary: Color(0xff5468f7),
      onPrimary: Colors.white,
      primaryVariant:  Color(0xff354355),
      secondary: Colors.red,
      surface: Color(0xffFFFFFF)
    ),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF),
      elevation: 3.0,
      margin: EdgeInsets.all(20.0)
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline4: TextStyle(
        color: lightAppColors.text,
        fontSize: 28.0,
      ),
      headline5: TextStyle(
        color: lightAppColors.text,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      ),
      headline6: TextStyle(
        color: lightAppColors.text,
        fontWeight: FontWeight.bold,
        fontSize: 19.0,
      ),
      subtitle2: TextStyle(
        color: lightAppColors.text,
        fontSize: 18.0,
      ),
      subtitle1: TextStyle(
        color: lightAppColors.text,
        fontSize: 18.0,
      ),
      bodyText1: TextStyle(
        color: lightAppColors.textSecondary,
        height: 1.4,
        fontSize: 16.0,
      ),
      bodyText2: TextStyle(
        color: lightAppColors.text,
        height: 1.4,
        fontSize: 14.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF212529),
    appBarTheme: AppBarTheme(
      color: Color(0xFF212529),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    backgroundColor: Color(0xFF202125),
    colorScheme: ColorScheme.light(
      primary: Color(0xFFE0E6E9),
      onPrimary: Colors.white,
      primaryVariant:  Color(0xff354355),
      secondary: Colors.red,
      surface: Color(0xFF2a2e32)
    ),
    cardTheme: CardTheme(
      color: Color(0xFF2a2e32),
      elevation: 3.0,
      margin: EdgeInsets.all(20.0)
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      headline4: TextStyle(
        color: darkAppColors.text,
        fontSize: 28.0,
      ),
      headline5: TextStyle(
        color: darkAppColors.text,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 19.0,
      ),
      subtitle2: TextStyle(
        color: darkAppColors.text,
        fontSize: 18.0,
      ),
      subtitle1: TextStyle(
        color: darkAppColors.text,
        fontSize: 18.0,
      ),
      bodyText1: TextStyle(
        color: darkAppColors.textSecondary,
        height: 1.4,
        fontSize: 16.0,
      ),
      bodyText2: TextStyle(
        color: darkAppColors.text,
        height: 1.4,
        fontSize: 14.0,
      ),
    ),
  );
}


// Unique theme colours
class LightThemeColors {

  Color text;
  Color textSecondary;

  LightThemeColors() {
      text = Color(0xff797979);
      textSecondary = Color(0xffA4A4A4);
  }
}

class DarkThemeColors {

  Color text;
  Color textSecondary;

  DarkThemeColors() {
      text = Colors.white;
      textSecondary = Color(0xFF6f7275);
  }
}