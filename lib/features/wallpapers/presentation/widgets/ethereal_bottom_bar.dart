import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

enum NavItem { home, browse, favorites, trending }

class EtherealBottomBar extends StatelessWidget {
  final NavItem activeItem;

  const EtherealBottomBar({super.key, required this.activeItem});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: bottomPadding + 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          width: MediaQuery.of(context).size.width * 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: AppColors.editorialShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      Icons.home_max_rounded,
                      activeItem == NavItem.home,
                      () => context.go('/'),
                    ),
                    _buildNavItem(
                      context,
                      Icons.grid_view_rounded,
                      activeItem == NavItem.browse,
                      () => context.go('/category/Explore'),
                    ),
                    _buildNavItem(
                      context,
                      Icons.favorite_rounded,
                      activeItem == NavItem.favorites,
                      () => context.go('/favorites'),
                    ),
                    _buildNavItem(
                      context,
                      Icons.local_fire_department_rounded,
                      activeItem == NavItem.trending,
                      () => context.go('/category/Trending'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: isActive
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: Colors.grey.shade400),
            ),
    );
  }
}
