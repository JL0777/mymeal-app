import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FastFoodScreen extends StatelessWidget {
  const FastFoodScreen({super.key});

  static const List<_FastFoodCategory> _categories = [
    _FastFoodCategory(label: 'Hamburguesas', icon: Icons.lunch_dining),
    _FastFoodCategory(label: 'Pizzas', icon: Icons.local_pizza_outlined),
    _FastFoodCategory(label: 'Perros calientes', icon: Icons.fastfood_outlined),
    _FastFoodCategory(label: 'Papas fritas', icon: Icons.restaurant_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 20,
        endIndent: 20,
        color: Color(0xFFF0F0F0),
      ),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return _FastFoodTile(category: cat);
      },
    );
  }
}

class _FastFoodTile extends StatelessWidget {
  final _FastFoodCategory category;
  const _FastFoodTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: navegar al listado
      },
      splashColor: AppTheme.lightOrange,
      highlightColor: AppTheme.lightOrange.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(category.icon, size: 36, color: AppTheme.primaryOrange),
            ),
            const SizedBox(width: 20),
            Text(
              category.label.toUpperCase(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppTheme.textDark,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }
}

class _FastFoodCategory {
  final String label;
  final IconData icon;
  const _FastFoodCategory({required this.label, required this.icon});
}