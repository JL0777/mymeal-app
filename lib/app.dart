import 'package:flutter/material.dart';

class MyMealApp extends StatelessWidget {
  const MyMealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMeal',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'MyMeal App',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
