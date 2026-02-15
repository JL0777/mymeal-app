import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';

/// Pantalla de bienvenida de la aplicación MyMeal.
/// Es la primera pantalla que ve el usuario al abrir la app.
/// Contiene el logo, un botón para iniciar sesión y un enlace para registrarse.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Stack nos permite apilar capas una encima de la otra.
        // Orden: fondo → overlay oscuro → contenido
        children: [
          // ─────────────────────────────────────────────────────
          // CAPA 1: Imagen de fondo
          // Positioned.fill hace que la imagen ocupe toda la pantalla.
          // BoxFit.cover garantiza que la imagen no se deforme.
          // ─────────────────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),

          // ─────────────────────────────────────────────────────
          // CAPA 2: Contenido principal
          // SafeArea evita que el contenido quede detrás del
          // notch, la cámara o la barra de estado del celular.
          // ─────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Espacio pequeño en la parte superior para
                // que el logo quede en el tercio superior de la pantalla.
                const Spacer(flex: 1),

                // ── LOGO DE LA APLICACIÓN ──────────────────────
                // Aumentamos el width a 750 para que sea más grande.
                Image.asset('assets/images/logo_mymeal.png', width: 750),

                // Espacio entre el logo y los botones.
                // flex: 1 es menor que antes para subir los botones.
                const Spacer(flex: 1),

                // ── BOTÓN INICIAR SESIÓN ───────────────────────
                // Padding horizontal para que el botón no llegue
                // hasta los bordes de la pantalla.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    // double.infinity hace que el botón ocupe
                    // todo el ancho disponible dentro del Padding.
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegamos a la pantalla de inicio de sesión
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Color naranja principal de la app
                        backgroundColor: const Color(0xFFE8651A),
                        foregroundColor: Colors.white,
                        // shape le da los bordes redondeados al botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Espacio entre el botón y el texto de registro
                const SizedBox(height: 20),

                // ── TEXTO "¿No tienes cuenta? Regístrate" ───────
                // GestureDetector detecta cuando el usuario toca el texto
                // y ejecuta la navegación hacia la pantalla de registro.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Texto normal en blanco
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    // GestureDetector convierte el texto en un elemento
                    // tocable, como si fuera un enlace web.
                    GestureDetector(
                      onTap: () {
                        // Navigator.push nos lleva a una nueva pantalla
                        // manteniendo la pantalla anterior en el historial.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Color(0xFFE8651A),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFE8651A),
                        ),
                      ),
                    ),
                  ],
                ),

                // Espacio al fondo para que el contenido no quede
                // pegado al borde inferior de la pantalla.
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
