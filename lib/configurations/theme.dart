import 'package:flutter/material.dart';

final ThemeData dayTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  textTheme: TextTheme(
    headline1:
        TextStyle(color: Colors.black87, fontSize: 29.0, fontFamily: 'Jinling'),
    button:
        TextStyle(color: Colors.black87, fontSize: 29.0, fontFamily: 'Jinling'),
    subtitle1: TextStyle(
        color: Colors.black54,
        fontSize: 21.5,
        fontFamily: 'Jinling',
        letterSpacing: 2,
        height: 2),
    caption:
        TextStyle(color: Colors.grey[500], fontSize: 23.0, fontFamily: 'Song'),
    subtitle2:
        TextStyle(color: Colors.grey[500], fontSize: 16.0, fontFamily: 'Song'),
    bodyText1: TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontSize: 16.0,
        fontFamily: 'Jinling',
        letterSpacing: 1.4,
        height: 1.8),
  ),
  accentColor: Colors.grey,
);

final ThemeData nightTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  backgroundColor: Color.fromARGB(255, 99, 12, 95),
  appBarTheme: AppBarTheme(color: Colors.white),
  textTheme: TextTheme(
    title: TextStyle(color: Colors.black87, fontSize: 31.0, fontFamily: 'Song'),
    subtitle:
        TextStyle(color: Colors.black54, fontSize: 28.0, fontFamily: 'Song'),
    caption:
        TextStyle(color: Colors.grey[500], fontSize: 23.0, fontFamily: 'Song'),
    display2:
        TextStyle(color: Colors.grey[500], fontSize: 16.0, fontFamily: 'Song'),
  ),
  accentColor: Colors.grey,
);
