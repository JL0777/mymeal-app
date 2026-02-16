import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Tab de pedidos realizados.
/// Escucha en tiempo real la colección "pedidos" de Firestore.
/// Los datos del cliente se consultan desde la colección "clientes".
/// Las direcciones se consultan desde la colección "direcciones".
class PedidosTab extends StatelessWidget {
  const PedidosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // StreamBuilder escucha cambios en tiempo real en Firestore.
      stream: FirebaseFirestore.instance
          .collection('pedidos')
          .orderBy('fecha', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Mientras carga mostramos un spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE8651A)),
          );
        }

        // Si hay error mostramos mensaje
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar pedidos'));
        }

        // Si no hay pedidos mostramos mensaje vacío
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No hay pedidos aún',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Si hay pedidos los mostramos en lista
        final pedidos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            // Obtenemos los datos básicos del pedido
            final data = pedidos[index].data() as Map<String, dynamic>;
            final clienteUid = data['clienteUid'] ?? '';
            final nombrePedido = data['nombrePedido'] ?? 'Sin nombre';
            final estado = data['estado'] ?? 'Pendiente';
            final imagenUrl = data['imagenUrl'] ?? '';
            final valorPedido = data['valorPedido'] ?? 0;

            return _buildPedidoCard(
              context: context,
              numero: index + 1,
              clienteUid: clienteUid,
              nombrePedido: nombrePedido,
              estado: estado,
              imagenUrl: imagenUrl,
              pedidoId: pedidos[index].id,
              valorPedido: valorPedido,
            );
          },
        );
      },
    );
  }

  /// Construye la tarjeta visual de cada pedido.
  Widget _buildPedidoCard({
    required BuildContext context,
    required int numero,
    required String clienteUid,
    required String nombrePedido,
    required String estado,
    required String imagenUrl,
    required String pedidoId,
    required num valorPedido,
  }) {
    // El color del estado cambia según su valor
    Color colorEstado;
    switch (estado) {
      case 'Realizado':
        colorEstado = Colors.green;
        break;
      case 'Enviado':
        colorEstado = Colors.blue;
        break;
      default:
        colorEstado = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── NÚMERO DEL PEDIDO ──────────────────────────────
        Text(
          'Pedido #$numero:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),

        const SizedBox(height: 6),

        // ── CLIENTE, TIPO Y VALOR ──────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera fila: Cliente y Tipo
            Row(
              children: [
                const Text(
                  'Cliente: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                // Consultamos el nombre del cliente desde la colección clientes
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('clientes')
                      .doc(clienteUid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('...');
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    final nombre = data?['nombre'] ?? 'Sin nombre';
                    return Text(nombre);
                  },
                ),
                const SizedBox(width: 16),
                const Text(
                  'Tipo: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Expanded(child: Text(nombrePedido)),
              ],
            ),

            const SizedBox(height: 4),

            // Segunda fila: Valor del pedido
            Row(
              children: [
                const Text(
                  'Valor: ',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$${valorPedido.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFFE8651A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── IMAGEN Y ACCIONES ──────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del pedido
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagenUrl.isNotEmpty
                  ? Image.network(
                      imagenUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imagenPlaceholder(),
                    )
                  : _imagenPlaceholder(),
            ),

            const SizedBox(width: 12),

            // Estado y botón
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── SELECT DE ESTADO ───────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Estado del pedido: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        // Dropdown para cambiar estado
                        DropdownButton<String>(
                          value: estado,
                          underline: const SizedBox(),
                          isDense: true,
                          style: TextStyle(
                            color: colorEstado,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Realizado',
                              child: Text('Realizado'),
                            ),
                            DropdownMenuItem(
                              value: 'Enviado',
                              child: Text('Enviado'),
                            ),
                          ],
                          onChanged: (nuevoEstado) async {
                            if (nuevoEstado != null) {
                              try {
                                // Actualizamos el estado en Firestore
                                await FirebaseFirestore.instance
                                    .collection('pedidos')
                                    .doc(pedidoId)
                                    .update({'estado': nuevoEstado});

                                // Mostramos confirmación con el estado actualizado
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Estado cambiado a "$nuevoEstado" correctamente ✓',
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Si hay error lo mostramos
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error al cambiar el estado: $e',
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── BOTÓN INFO ─────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Muestra modal con info completa del cliente
                        _mostrarInfoCliente(
                          context: context,
                          pedidoId: pedidoId,
                          numeroPedido: numero,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8651A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text(
                        'Info. Cliente y pedido',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const Divider(height: 24),
      ],
    );
  }

  /// Imagen placeholder cuando no hay imagen del pedido.
  Widget _imagenPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.fastfood, color: Colors.grey, size: 36),
    );
  }

  /// Modal con información completa del cliente y su dirección.
  /// Consulta 3 colecciones: pedidos → clientes → direcciones
  void _mostrarInfoCliente({
    required BuildContext context,
    required String pedidoId,
    required int numeroPedido,
  }) {
    showDialog(
      context: context,
      builder: (context) => StreamBuilder<DocumentSnapshot>(
        // Primero obtenemos el pedido
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .doc(pedidoId)
            .snapshots(),
        builder: (context, pedidoSnapshot) {
          if (!pedidoSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE8651A)),
            );
          }

          final pedidoData =
              pedidoSnapshot.data!.data() as Map<String, dynamic>;
          final clienteUid = pedidoData['clienteUid'] ?? '';
          final direccionId = pedidoData['direccionId'] ?? '';

          if (clienteUid.isEmpty) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 16),
                    Text('No se encontró información del cliente'),
                  ],
                ),
              ),
            );
          }

          // Consultamos datos del cliente en la colección "clientes"
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('clientes')
                .doc(clienteUid)
                .snapshots(),
            builder: (context, clienteSnapshot) {
              if (!clienteSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE8651A)),
                );
              }

              final clienteData =
                  clienteSnapshot.data!.data() as Map<String, dynamic>?;
              final nombre = clienteData?['nombre'] ?? 'Sin nombre';
              final telefono = clienteData?['telefono'] ?? 'Sin teléfono';

              // Consultamos la dirección usada en el pedido
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('direcciones')
                    .doc(direccionId)
                    .snapshots(),
                builder: (context, direccionSnapshot) {
                  String direccion = 'Sin dirección';
                  String barrio = 'Sin barrio';
                  String tipoVivienda = 'No especificado';
                  String instruccionesExtra =
                      'No hay instrucciones adicionales';

                  if (direccionSnapshot.hasData &&
                      direccionSnapshot.data!.exists) {
                    final direccionData =
                        direccionSnapshot.data!.data() as Map<String, dynamic>?;
                    direccion = direccionData?['direccion'] ?? 'Sin dirección';
                    barrio = direccionData?['barrio'] ?? 'Sin barrio';
                    tipoVivienda =
                        direccionData?['tipoVivienda'] ?? 'No especificado';
                    instruccionesExtra =
                        direccionData?['instruccionesExtra'] ??
                        'No hay instrucciones adicionales';
                  }

                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── TÍTULO ──────────────────────────────
                            const Center(
                              child: Text(
                                'Información del\nCliente',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE8651A),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ── CLIENTE ─────────────────────────────
                            _buildInfoRow('Cliente:', nombre),

                            const SizedBox(height: 12),

                            // ── TELÉFONO ────────────────────────────
                            _buildInfoRow('Teléfono:', telefono),

                            const SizedBox(height: 12),

                            // ── DIRECCIÓN ───────────────────────────
                            _buildInfoRow('Dirección pedido:', direccion),

                            const SizedBox(height: 12),

                            // ── BARRIO ──────────────────────────────
                            _buildInfoRow('Barrio:', barrio),

                            const SizedBox(height: 12),

                            // ── TIPO DE VIVIENDA ────────────────────
                            _buildInfoRow('Tipo de vivienda:', tipoVivienda),

                            const SizedBox(height: 12),

                            // ── INSTRUCCIONES EXTRA ─────────────────
                            _buildInfoRow(
                              'Instrucciones adicionales:',
                              instruccionesExtra,
                            ),

                            const SizedBox(height: 32),

                            // ── BOTÓN VER PEDIDO ────────────────────
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _mostrarInfoPedido(
                                      context: context,
                                      pedidoId: pedidoId,
                                      numeroPedido: numeroPedido,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE8651A),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    'Ver pedido',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Modal con información detallada del pedido.
  /// Muestra número, nombre, descripción y valor del pedido.
  /// Modal con información detallada del pedido.
  /// Muestra imagen, número, nombre, descripción y valor del pedido.
  void _mostrarInfoPedido({
    required BuildContext context,
    required String pedidoId,
    required int numeroPedido,
  }) {
    showDialog(
      context: context,
      builder: (context) => StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .doc(pedidoId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE8651A)),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final nombrePedido = data['nombrePedido'] ?? 'Sin nombre';
          final descripcion =
              data['descripcion'] ?? 'Sin descripción del pedido';
          final imagenUrl = data['imagenUrl'] ?? '';

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── FLECHA ATRÁS ────────────────────────────
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _mostrarInfoCliente(
                            context: context,
                            pedidoId: pedidoId,
                            numeroPedido: numeroPedido,
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── TÍTULO ──────────────────────────────
                    const Center(
                      child: Text(
                        'Información del\nPedido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE8651A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── IMAGEN DEL PEDIDO ───────────────────
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imagenUrl.isNotEmpty
                            ? Image.network(
                                imagenUrl,
                                width: 150,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.fastfood,
                                    color: Colors.grey,
                                    size: 60,
                                  ),
                                ),
                              )
                            : Container(
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── NÚMERO DEL PEDIDO ───────────────────
                    _buildInfoRow('Número del pedido:', '#$numeroPedido'),

                    const SizedBox(height: 16),

                    // ── NOMBRE DEL PEDIDO ───────────────────
                    _buildInfoRow('Nombre del pedido:', nombrePedido),

                    const SizedBox(height: 16),

                    // ── DESCRIPCIÓN ─────────────────────────
                    _buildInfoRow('Descripción del pedido:', descripcion),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget reutilizable para mostrar filas de información.
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, color: Colors.grey)),
      ],
    );
  }
}
