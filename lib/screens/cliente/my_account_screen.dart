import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 24),

          // ── Avatar + Name placeholder ──
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryOrange,
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.primaryOrange,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mi Cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Divider(height: 1),

          // ── Menu items ──
          _AccountTile(
            icon: Icons.person_outline,
            label: 'Mis datos',
            onTap: () {},
          ),
          _AccountTile(
            icon: Icons.location_on_outlined,
            label: 'Mis direcciones',
            onTap: () {},
          ),
          _AccountTile(
            icon: Icons.notifications_outlined,
            label: 'Notificaciones',
            onTap: () {},
          ),
          _AccountTile(
            icon: Icons.help_outline,
            label: 'Ayuda',
            onTap: () {},
          ),
          const Divider(height: 1),
          _AccountTile(
            icon: Icons.logout,
            label: 'Cerrar sesión',
            color: Colors.red.shade400,
            onTap: () {
              // TODO: logout logic
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textDark;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(icon, color: c, size: 24),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: c,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 46),
      ],
    );
  }
}