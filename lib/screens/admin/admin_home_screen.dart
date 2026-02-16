import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymeal_app/screens/welcome_screen.dart';

/// Pantalla principal del administrador.
/// Solo accesible para usuarios con rol "admin" en Firestore.
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyMeal - Admin'),
        backgroundColor: Colors.black87,
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
            const Icon(Icons.admin_panel_settings,
                size: 80, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              'Panel Admin\n${FirebaseAuth.instance.currentUser?.email ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Panel de administración en construcción 🚧',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}