import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio de autenticación.
/// Verifica el rol del usuario consultando Firestore.
class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna según el rol en Firestore.
  /// Si no encuentra documento retorna "cliente" por defecto.
  Future<String> obtenerRolUsuario(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['rol'] ?? 'cliente';
      }

      return 'cliente';
    } catch (e) {
      return 'cliente';
    }
  }
}