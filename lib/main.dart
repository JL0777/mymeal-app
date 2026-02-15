import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo ya lo tienes en tu proyecto
import 'screens/welcome_screen.dart';

/// Punto de entrada de la aplicación.
/// Firebase debe inicializarse ANTES de correr la app.
void main() async {
  // Necesario para que Firebase pueda inicializarse
  // antes de que Flutter arranque la interfaz
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con la configuración del proyecto
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Meal',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}