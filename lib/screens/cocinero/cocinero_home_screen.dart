import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymeal_app/screens/welcome_screen.dart';

/// Pantalla principal del cocinero.
/// Solo accesible para usuarios con rol "cocinero" en Firestore.
class CocineroHomeScreen extends StatelessWidget {
  const CocineroHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyMeal - Cocinero'),
        backgroundColor: const Color(0xFFE8651A),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          // ── BOTÓN CERRAR SESIÓN ──────────────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cerramos la sesión en Firebase
              await FirebaseAuth.instance.signOut();

              // Regresamos a bienvenida eliminando el historial
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              size: 80,
              color: Color(0xFFE8651A),
            ),
            const SizedBox(height: 16),
            Text(
              'Bienvenido cocinero\n${FirebaseAuth.instance.currentUser?.email ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Panel de cocina en construcción 🚧',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}