import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymeal_app/screens/welcome_screen.dart';

/// Pantalla principal de la app.
/// Es la primera pantalla que ve el usuario después de iniciar sesión.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyMeal'),
        backgroundColor: const Color(0xFFE8651A),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Quita el botón atrás
        actions: [
          // ── BOTÓN CERRAR SESIÓN ──────────────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Cerramos la sesión en Firebase
              await FirebaseAuth.instance.signOut();

              // Regresamos a la pantalla de bienvenida eliminando
              // todo el historial de navegación
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
              Icons.restaurant_menu,
              size: 80,
              color: Color(0xFFE8651A),
            ),
            const SizedBox(height: 16),
            // Muestra el correo del usuario que inició sesión
            Text(
              '¡Bienvenido, ${FirebaseAuth.instance.currentUser?.email ?? 'Usuario'}!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pantalla principal en construcción 🚧',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}