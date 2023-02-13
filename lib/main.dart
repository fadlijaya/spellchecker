import 'package:flutter/material.dart';
import 'package:spellchecker/constants/constants.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'pages/home_page.dart';

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
      routes: {
        '/homePage': (_) => HomePage()
      }
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
      imageSize: 90,
      text: titleApp,
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }
}
