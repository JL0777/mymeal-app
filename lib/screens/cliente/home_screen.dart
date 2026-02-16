import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'traditional_food_screen.dart';
import 'fast_food_screen.dart';
import 'drinks_screen.dart';
import 'my_orders_screen.dart';
import 'my_account_screen.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/cart_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentBottomIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCartModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => const CartModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _currentBottomIndex == 0
            ? _HomeContent(
                key: const ValueKey('home'),
                tabController: _tabController,
                onCartTap: _openCartModal,
              )
            : _currentBottomIndex == 1
                ? const MyOrdersScreen(key: ValueKey('orders'))
                : const MyAccountScreen(key: ValueKey('account')),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) => setState(() => _currentBottomIndex = index),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  HOME CONTENT
// ─────────────────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  final TabController tabController;
  final VoidCallback onCartTap;

  const _HomeContent({
    super.key,
    required this.tabController,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(onCartTap: onCartTap),
        _CategoryTabBar(controller: tabController),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              TraditionalFoodScreen(),
              FastFoodScreen(),
              DrinksScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final VoidCallback onCartTap;
  const _Header({required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: 170 + statusBarHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, statusBarHeight + 10, 20, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 42),
                Image.asset(
                  'assets/images/logo_mymeal.png',
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text(
                    'MY 🍽 MEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onCartTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '¿Qué deseas comer\nel día de hoy?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  CATEGORY TAB BAR
// ─────────────────────────────────────────────────────────
class _CategoryTabBar extends StatelessWidget {
  final TabController controller;
  const _CategoryTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        labelColor: AppTheme.primaryOrange,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: AppTheme.primaryOrange,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          height: 1.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          height: 1.3,
        ),
        tabs: const [
          Tab(text: 'Comida\ntradicional'),
          Tab(text: 'Comida\nRápida'),
          Tab(text: 'Bebidas'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  BOTTOM NAV BAR
// ─────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryOrange,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 28),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, size: 28),
            activeIcon: Icon(Icons.receipt_long, size: 28),
            label: 'Mis Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Mi Cuenta',
          ),
        ],
      ),
    );
  }
}