import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
  fontFamily: 'ProductSans',
  backgroundColor: Colors.white,
  textTheme: const TextTheme(
    button: TextStyle(color: Colors.white70),
  ),
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    color: Color(0xff93C1EF),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.blue),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: const Color(0xffF5F6FA),
    hintStyle: const TextStyle(
      fontSize: 14,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black54,
  ),
  cardColor: Color(0xffF5F6FA),
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showSelectedLabels: false,
    unselectedItemColor: Colors.grey,
    selectedItemColor: Colors.black,
  ),
);

var darkThemeDatas = ThemeData(
  fontFamily: 'ProductSans',
  backgroundColor: const Color(0xff272727),
  textTheme: const TextTheme(
    button: TextStyle(color: Colors.white),
  ),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    color: Color(0xff93C1EF),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.blue),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: Color.fromARGB(255, 73, 73, 73),
    hintStyle: const TextStyle(
      fontSize: 14,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white60,
  ),
  cardColor: const Color.fromARGB(255, 73, 73, 73),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    showSelectedLabels: false,
    unselectedItemColor: Colors.white54,
    selectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
