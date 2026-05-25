import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';

import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/wallpapers_masonry_grid.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../core/theme/theme_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WallpaperCubit>()..fetchWallpapers(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: BlocBuilder<WallpaperCubit, WallpaperState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<WallpaperCubit>().fetchWallpapers(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),

                  // Hero Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Muse',
                            style: AppTextStyles.headlineLarge,
                          ),
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

                  // Gallery Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
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
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppBar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.7),
            elevation: 0,
            title: Text(
              'EtherealWalls',
              style: AppTextStyles.headlineMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                color: iconColor,
                onPressed: () => context.push('/search'),
              ),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return IconButton(
                    icon: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                    ),
                    color: iconColor,
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  );
                },
              ),
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
    return const EtherealLoading();
  }

  Widget _buildGallery(WallpaperState state) {
    if (state is WallpaperLoaded) {
      return WallpapersMasonryGrid(wallpapers: state.wallpapers);
    } else if (state is WallpaperError) {
      return SliverFillRemaining(
        child: EtherealError(
          message: state.message,
          onRetry: () => context.read<WallpaperCubit>().fetchWallpapers(),
        ),
      );
    }
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: EtherealLoading(),
      ),
    );
  }
}
