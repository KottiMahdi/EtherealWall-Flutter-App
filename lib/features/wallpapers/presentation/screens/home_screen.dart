import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';

import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/wallpapers_masonry_grid.dart';
import '../widgets/ethereal_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final categories = ['Nature', 'Abstract', 'Minimal', 'Urban'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WallpaperCubit>()..fetchWallpapers(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: BlocBuilder<WallpaperCubit, WallpaperState>(
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    
                    // Hero Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daily Muse', style: AppTextStyles.headlineLarge),
                            const SizedBox(height: 4),
                            Text(
                              'Curated art for your digital sanctuary.',
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 24),
                            _buildHeroCarousel(state),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),

                    // Categories Section
                    SliverToBoxAdapter(child: _buildCategorySection(context)),

                    // Gallery Section Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Text(
                          'Trending Now',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    // Masonry Grid
                    _buildGallery(state),
                  ],
                ),
                const EtherealBottomBar(activeItem: NavItem.home),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppBar(
            backgroundColor: AppColors.background.withValues(alpha: 0.7),
            elevation: 0,
            title: Text(
              'EtherealWalls',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel(WallpaperState state) {
    if (state is WallpaperLoaded) {
      return HeroCarousel(wallpapers: state.wallpapers);
    }
    return Container(
      height: 420,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/category/Trending'),
                child: Text('Explore all', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => CategoryChip(
              label: categories[index],
              isSelected: false,
              onTap: () => context.push('/category/${categories[index]}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(WallpaperState state) {
    if (state is WallpaperLoaded) {
      return WallpapersMasonryGrid(wallpapers: state.wallpapers);
    } else if (state is WallpaperError) {
      return SliverFillRemaining(child: Center(child: Text(state.message)));
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }
}
