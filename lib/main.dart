import 'package:flutter/material.dart';
import 'package:springai_mobile_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taju Ai App',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
      ),

      home: HomeScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}
