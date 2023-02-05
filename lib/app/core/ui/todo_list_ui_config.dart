import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListUiConfig {
  TodoListUiConfig._();
  static ThemeData get theme => ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        primaryColor: const Color(0xff5c77CE),
        primaryColorLight: const Color(0xffabcbf7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff5c77ce),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff5c77ce),
        ),
        // appBarTheme: AppBarTheme(color: const Color(0xff5c77ce)),
      );
}
