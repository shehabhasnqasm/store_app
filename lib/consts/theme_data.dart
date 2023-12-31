import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.black : const Color.fromARGB(255, 232, 229, 226),
      primaryColor: isDarkTheme ? Colors.black : Colors.grey.shade300,
      // backgroundColor: isDarkTheme ? Colors.grey.shade700 : Colors.white,
      backgroundColor:
          isDarkTheme ? Colors.grey.shade700 : Colors.white.withOpacity(0.9),
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
      highlightColor:
          isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      cardColor:
          isDarkTheme ? const Color.fromARGB(255, 21, 19, 19) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : Colors.black,
      ),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
      //     .copyWith(secondary: Colors.deepPurple),
    );
  }
}
