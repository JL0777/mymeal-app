import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymeal_app/screens/welcome_screen.dart';
import 'tabs/pedidos_tab.dart';
import 'tabs/productos_tab.dart';
import 'tabs/ventas_tab.dart';

/// Pantalla principal del administrador.
/// Contiene 3 tabs: Pedidos, Gestión de Productos y Reporte de Ventas.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Índice del tab actualmente seleccionado
  int _tabSeleccionado = 0;

  // Lista de tabs disponibles
  final List<Widget> _tabs = const [PedidosTab(), ProductosTab(), VentasTab()];

  // Títulos del header según el tab activo
  final List<String> _titulos = [
    'Pedidos realizados\ny listos',
    'Gestión de\nProductos',
    'Reporte de\nVentas',
  ];

  /// Muestra el modal de perfil con opción de cerrar sesión
  void _mostrarPerfilModal() {
    final email =
        FirebaseAuth.instance.currentUser?.email ?? 'admin@mymeal.com';

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── ÍCONO DE USUARIO ─────────────────────────
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 16),

              // ── TÍTULO ───────────────────────────────────
              const Text(
                'Perfil de Usuario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // ── EMAIL DEL ADMIN ──────────────────────────
              Text(
                email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              const Divider(),

              const SizedBox(height: 16),

              // ── BOTÓN CERRAR SESIÓN ──────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Cerramos el modal primero
                    Navigator.pop(context);

                    // Mostramos mensaje de confirmación
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Sesión cerrada exitosamente ✓',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }

                    // Cerramos la sesión en Firebase
                    await FirebaseAuth.instance.signOut();

                    // Regresamos a la pantalla de bienvenida
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ─────────────────────────────────────────────────────
          // HEADER: Imagen de fondo con overlay anaranjado,
          // logo de MyMeal e ícono de perfil.
          // ─────────────────────────────────────────────────────
          SizedBox(
            height: 230,
            child: Stack(
              children: [
                // Imagen de fondo
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // Overlay anaranjado semitransparente
                Positioned.fill(
                  child: Container(
                    color: const Color.fromARGB(
                      255,
                      251,
                      168,
                      120,
                    ).withOpacity(0.55),
                  ),
                ),

                // Contenido del header
                SafeArea(
                  child: Stack(
                    children: [
                      // Logo centrado arriba de todo
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 1,
                          ),
                          child: Image.asset(
                            'assets/images/logo_mymeal.png',
                            width: 200,
                          ),
                        ),
                      ),

                      // Texto del título e ícono de perfil abajo
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8,
                          ),
                          child: Row(
                            children: [
                              // Texto del título según tab activo
                              Expanded(
                                child: Text(
                                  _titulos[_tabSeleccionado],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Ícono de perfil para cerrar sesión
                              GestureDetector(
                                onTap: _mostrarPerfilModal,
                                child: Container(
                                  width: 55, 
                                  height: 55, 
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─────────────────────────────────────────────────────
          // TABS: Selector de secciones con línea naranja abajo
          // en el tab activo.
          // ─────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab('Pedidos\nRealizados', 0),
                _buildTab('Gestión de\nProductos', 1),
                _buildTab('Reporte de\nVentas', 2),
              ],
            ),
          ),

          // Línea separadora
          const Divider(height: 1, color: Colors.grey),

          // ─────────────────────────────────────────────────────
          // CONTENIDO: Muestra el tab seleccionado
          // ─────────────────────────────────────────────────────
          Expanded(child: _tabs[_tabSeleccionado]),
        ],
      ),
    );
  }

  /// Construye cada tab del selector con su texto
  /// y línea naranja cuando está activo.
  Widget _buildTab(String titulo, int index) {
    final bool activo = _tabSeleccionado == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabSeleccionado = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                // Línea naranja solo en el tab activo
                color: activo ? const Color(0xFFE8651A) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: activo ? FontWeight.bold : FontWeight.normal,
              // Texto naranja si está activo, gris si no
              color: activo ? const Color(0xFFE8651A) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
