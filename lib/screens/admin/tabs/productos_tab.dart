import 'package:flutter/material.dart';

/// Tab de gestión de productos.
/// Aquí el admin podrá agregar, editar y eliminar productos del menú.
class ProductosTab extends StatelessWidget {
  const ProductosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Gestión de Productos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'En construcción 🚧',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}