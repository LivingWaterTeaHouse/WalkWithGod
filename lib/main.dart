import 'package:flutter/material.dart';
import 'package:walk_with_god/configurations/theme.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/MainScreen.dart';
import 'screens/PersonalManagementScreen.dart';
import 'screens/TextStyleGuideScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walk With God',
      debugShowCheckedModeBanner: false,
      theme: dayTheme,
      home: MainScreen(),
      routes: {
        //LoginScreen.routeName: (ctx) => LoginScreen(),
        //SignupScreen.routeName: (ctx) => SignupScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        PersonalManagementScreen.routeName: (ctx) => PersonalManagementScreen(),
        TextStyleGuideScreen.routeName: (ctx) => TextStyleGuideScreen(),
      },
    );
  }
}
