import 'package:flutter/material.dart';
import 'package:my_trial_app/SplashScreen.dart';
import 'package:my_trial_app/LoginScreen.dart';
import 'package:my_trial_app/HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashScreen(),
      '/login':(context) => const LoginScreen(),
      '/home': (context) => const HomeScreen(),
    },
  ));
}
