import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(const FoodPlanApp());
}

class FoodPlanApp extends StatelessWidget {
  const FoodPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedGreen = Color(0xFF2E7D32); // hijau utama sesuai identitas FoodPlan

    return MaterialApp(
      title: 'FoodPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedGreen),
        scaffoldBackgroundColor: const Color(0xFFF7F7F2),
      ),
      home: const SplashScreen(),
    );
  }
}