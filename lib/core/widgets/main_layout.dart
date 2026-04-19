import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/app') return 0;
    if (location.startsWith('/app/exams')) return 1;
    if (location.startsWith('/app/tools')) return 2;
    if (location.startsWith('/app/blog')) return 3;
    if (location.startsWith('/app/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', isActive: selectedIndex == 0, onTap: () => context.go('/app')),
                _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Exams', isActive: selectedIndex == 1, onTap: () => context.go('/app/exams')),
                _NavItem(icon: Icons.build_outlined, activeIcon: Icons.build, label: 'Tools', isActive: selectedIndex == 2, onTap: () => context.go('/app/tools')),
                _NavItem(icon: Icons.article_outlined, activeIcon: Icons.article, label: 'Blog', isActive: selectedIndex == 3, onTap: () => context.go('/app/blog')),
                _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', isActive: selectedIndex == 4, onTap: () => context.go('/app/profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}