import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:mymeal_app/screens/admin/admin_home_screen.dart';
import 'package:mymeal_app/services/auth_service.dart';
import 'package:mymeal_app/screens/cocinero/cocinero_home_screen.dart';

/// Pantalla de inicio de sesión de usuarios existentes.
/// Usa Firebase Authentication para verificar las credenciales
/// con correo electrónico y contraseña.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar el texto de cada campo
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controla si el botón está cargando para evitar
  // que el usuario presione dos veces mientras inicia sesión
  bool _isLoading = false;

  // Controla si la contraseña es visible o no
  bool _passwordVisible = false;

  /// Liberamos los controladores de memoria cuando
  /// la pantalla se cierra para evitar fugas de memoria.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Método principal que inicia sesión con Firebase.
  /// Valida los campos antes de enviar a Firebase.
  Future<void> _iniciarSesion() async {
    // Validación: ningún campo puede estar vacío
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos.');
      return;
    }

    // Activamos el indicador de carga en el botón
    setState(() => _isLoading = true);

    try {
      // Iniciamos sesión en Firebase Auth
      UserCredential credenciales = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (mounted) {
        // Consultamos el rol del usuario en Firestore
        String rol = await AuthService().obtenerRolUsuario(
          credenciales.user!.uid,
        );

        // Mostramos aviso de inicio de sesión exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '¡Bienvenido de nuevo a MyMeal!',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (rol == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            (route) => false,
          );
        } else if (rol == 'cocinero') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CocineroHomeScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Capturamos errores específicos de Firebase y los mostramos
      String mensaje = 'Ocurrió un error al iniciar sesión.';

      if (e.code == 'user-not-found') {
        mensaje = 'No existe una cuenta con este correo.';
      } else if (e.code == 'wrong-password') {
        mensaje = 'La contraseña es incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido.';
      } else if (e.code == 'user-disabled') {
        mensaje = 'Esta cuenta ha sido deshabilitada.';
      } else if (e.code == 'invalid-credential') {
        mensaje = 'Correo o contraseña incorrectos.';
      }

      _mostrarError(mensaje);
    } finally {
      // Desactivamos el indicador de carga pase lo que pase
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Envía un correo de recuperación de contraseña al email ingresado.
  Future<void> _olvidasteContrasena() async {
    // Validación: el correo no puede estar vacío para recuperar contraseña
    if (_emailController.text.isEmpty) {
      _mostrarError('Ingresa tu correo para recuperar la contraseña.');
      return;
    }

    try {
      // Firebase envía un correo de restablecimiento de contraseña
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        // Confirmamos que el correo fue enviado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correo de recuperación enviado 📧'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _mostrarError('No se pudo enviar el correo: ${e.message}');
    }
  }

  /// Muestra un mensaje de error en pantalla usando un SnackBar rojo.
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─────────────────────────────────────────────────────
          // FONDO COMPLETO: Imagen de fondo que ocupa toda la pantalla.
          // alignment: bottomCenter muestra la parte inferior de la imagen.
          // ─────────────────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // Overlay oscuro sobre la imagen para mejorar legibilidad
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          // ─────────────────────────────────────────────────────
          // CONTENIDO PRINCIPAL: SafeArea para respetar el notch
          // y la barra de estado del celular.
          // ─────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── BOTÓN ATRÁS ──────────────────────────────
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // ── LOGO ─────────────────────────────────────
                const SizedBox(height: 8),
                Image.asset('assets/images/logo_mymeal.png', width: 750),
                const SizedBox(height: 16),

                // ─────────────────────────────────────────────
                // TARJETA FLOTANTE: El formulario flota sobre la imagen.
                // Mismo diseño que la pantalla de registro.
                // ─────────────────────────────────────────────
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Border radius de 8 en todas las esquinas
                      borderRadius: BorderRadius.circular(40),
                      // Sombra para darle el efecto flotante
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      // SingleChildScrollView permite hacer scroll
                      // si el teclado empuja el contenido hacia arriba
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── TAB INICIAR SESIÓN / REGISTRARSE ──
                          // El tab de Iniciar Sesión está activo (naranja)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                // Tab Iniciar Sesión (activo - naranja)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8651A),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      'INICIAR SESION',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                // Tab Registrarse (inactivo)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Reemplaza la pantalla actual por Registro
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        'REGISTRARSE',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── TÍTULO ───────────────────────────
                          const Text(
                            'BIENVENIDO A MyMeal!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── CAMPO CORREO ─────────────────────
                          _buildTextField(
                            label: 'Correo Electronico',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          // ── CAMPO CONTRASEÑA ─────────────────
                          // isPassword activa el ícono de ojo para
                          // mostrar u ocultar la contraseña
                          _buildTextField(
                            label: 'Contraseña',
                            controller: _passwordController,
                            isPassword: true,
                            isPasswordVisible: _passwordVisible,
                            onTogglePassword: () {
                              // Cambia el estado de visibilidad de la contraseña
                              setState(
                                () => _passwordVisible = !_passwordVisible,
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // ── LINK OLVIDASTE TU CONTRASEÑA ─────
                          // GestureDetector convierte el texto en enlace tocable
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _olvidasteContrasena,
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: Color(0xFFE8651A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── BOTÓN INICIAR SESIÓN ──────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              // Si está cargando desactivamos el botón
                              onPressed: _isLoading ? null : _iniciarSesion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8651A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  // Mientras carga muestra un spinner blanco
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'INICIAR SESION',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Método reutilizable para construir campos de texto.
  /// Incluye soporte para mostrar/ocultar contraseña con ícono de ojo.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      // Si es contraseña, oculta el texto según el estado de visibilidad
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
        prefixText: prefixText,
        // Ícono de ojo solo aparece en campos de contraseña
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  // Cambia el ícono según si la contraseña es visible o no
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        // Línea inferior solamente, sin borde completo
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        // Línea naranja cuando el campo está activo
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE8651A), width: 2),
        ),
      ),
    );
  }
}
