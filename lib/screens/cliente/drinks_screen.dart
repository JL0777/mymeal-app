import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DrinksScreen extends StatelessWidget {
  const DrinksScreen({super.key});

  static const List<_DrinkCategory> _categories = [
    _DrinkCategory(label: 'Jugos naturales',     icon: Icons.emoji_food_beverage_outlined),
    _DrinkCategory(label: 'Gaseosas',            icon: Icons.local_drink_outlined),
    _DrinkCategory(label: 'Bebidas calientes',   icon: Icons.coffee_outlined),
    _DrinkCategory(label: 'Agua y energizantes', icon: Icons.water_drop_outlined),
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
        return _DrinkTile(category: cat);
      },
    );
  }
}

class _DrinkTile extends StatelessWidget {
  final _DrinkCategory category;
  const _DrinkTile({required this.category});

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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
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

class _DrinkCategory {
  final String label;
  final IconData icon;
  const _DrinkCategory({required this.label, required this.icon});
}