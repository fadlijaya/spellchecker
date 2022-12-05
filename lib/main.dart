import 'package:flutter/material.dart';
import 'package:spellchecker/constants.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleApp,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreens(),
    );
  }
}

class SplashScreens extends StatelessWidget {
  const SplashScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const HomePage(),
      duration: 3000,
      imageSrc: "assets/icon_app.png",
      backgroundColor: Colors.blue,
    );
  }
}
