import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

/// Pantalla de registro de nuevos usuarios.
/// Usa Firebase Authentication para crear la cuenta
/// con correo electrónico y contraseña.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para capturar el texto de cada campo
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controla si el botón está cargando para evitar
  // que el usuario presione dos veces mientras registra
  bool _isLoading = false;

  // Controla si la contraseña es visible o no
  bool _passwordVisible = false;

  // Controla si confirmar contraseña es visible o no
  bool _confirmPasswordVisible = false;

  /// Liberamos los controladores de memoria cuando
  /// la pantalla se cierra para evitar fugas de memoria.
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Método principal que registra al usuario en Firebase.
  /// Valida los campos antes de enviar a Firebase.
  Future<void> _registrar() async {
    // Validación: ningún campo puede estar vacío
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos.');
      return;
    }

    // Validación: las contraseñas deben coincidir
    if (_passwordController.text != _confirmPasswordController.text) {
      _mostrarError('Las contraseñas no coinciden.');
      return;
    }

    // Validación: la contraseña debe tener al menos 6 caracteres
    if (_passwordController.text.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    // Activamos el indicador de carga en el botón
    setState(() => _isLoading = true);

    try {
      // Registramos el usuario en Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // Mostramos el aviso de registro exitoso en verde
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso! Bienvenido a MyMeal 🎉'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Esperamos 2 segundos para que el usuario vea el mensaje
        // antes de navegar al login
        await Future.delayed(const Duration(seconds: 2));

        // Navegamos al Login eliminando todas las pantallas anteriores
        // del historial para que no pueda regresar con el botón atrás
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Capturamos errores específicos de Firebase y los mostramos
      String mensaje = 'Ocurrió un error al registrarse.';

      if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido.';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es muy débil.';
      }

      _mostrarError(mensaje);
    } finally {
      // Desactivamos el indicador de carga pase lo que pase
      if (mounted) setState(() => _isLoading = false);
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
          // alignment: bottomCenter muestra la parte inferior de la imagen,
          // que es donde están los ingredientes más vistosos del diseño.
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
                // SizedBox pequeño para separar del botón atrás
                const SizedBox(height: 8),
                Image.asset('assets/images/logo_mymeal.png', width: 750),
                const SizedBox(height: 16),

                // ─────────────────────────────────────────────
                // TARJETA FLOTANTE: El formulario flota sobre la imagen.
                // margin solo en los lados para que llegue hasta el fondo.
                // borderRadius de 8 en todas las esquinas como en el diseño.
                // ─────────────────────────────────────────────
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Border radius de 8 en todas las esquinas (caja flotante)
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
                          // Contenedor gris redondeado que simula tabs
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                // Tab Iniciar Sesión (inactivo)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Reemplaza la pantalla actual por Login
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
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
                                        'INICIAR SESION',
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

                                // Tab Registrarse (activo - naranja)
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
                                      'REGISTRARSE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
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
                            'REGISTRATE A MyMeal!',
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

                          // ── CAMPO TELÉFONO ───────────────────
                          // prefixText agrega el +57 fijo al inicio
                          _buildTextField(
                            label: 'Numero de telefono',
                            controller: _phoneController,
                            prefixText: '+57 ',
                            keyboardType: TextInputType.phone,
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

                          const SizedBox(height: 16),

                          // ── CAMPO CONFIRMAR CONTRASEÑA ────────
                          _buildTextField(
                            label: 'Confirmar Contraseña',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            isPasswordVisible: _confirmPasswordVisible,
                            onTogglePassword: () {
                              // Cambia el estado de visibilidad de confirmar
                              setState(
                                () => _confirmPasswordVisible =
                                    !_confirmPasswordVisible,
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // ── BOTÓN REGISTRARSE ─────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              // Si está cargando desactivamos el botón
                              onPressed: _isLoading ? null : _registrar,
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
                                      'REGISTRARSE',
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