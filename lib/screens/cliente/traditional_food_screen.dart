import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TraditionalFoodScreen extends StatelessWidget {
  const TraditionalFoodScreen({super.key});

  static const List<_MealCategory> _categories = [
    _MealCategory(
      label: 'Desayuno',
      icon: Icons.free_breakfast_outlined,
      // Cambia por AssetImage cuando tengas las imágenes
    ),
    _MealCategory(
      label: 'Almuerzo',
      icon: Icons.lunch_dining_outlined,
    ),
    _MealCategory(
      label: 'Cena',
      icon: Icons.dinner_dining_outlined,
    ),
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
        return _MealCategoryTile(category: cat);
      },
    );
  }
}

class _MealCategoryTile extends StatelessWidget {
  final _MealCategory category;
  const _MealCategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: navegar al listado de platos de esta categoría
      },
      splashColor: AppTheme.lightOrange,
      highlightColor: AppTheme.lightOrange.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Row(
          children: [
            // ── Image / Icon placeholder ──
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                category.icon,
                size: 36,
                color: AppTheme.primaryOrange,
              ),
              // When you have real images, replace with:
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(14),
              //   child: Image.asset(category.imagePath, fit: BoxFit.cover),
              // ),
            ),
            const SizedBox(width: 20),
            // ── Label ──
            Text(
              category.label.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.textDark,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCategory {
  final String label;
  final IconData icon;
  // final String imagePath; // uncomment when using real images
  const _MealCategory({required this.label, required this.icon});
}