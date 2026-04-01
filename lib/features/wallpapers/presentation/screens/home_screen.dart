import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/wallpaper_grid_item.dart';
import '../widgets/ethereal_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final categories = ['All', 'Nature', 'Abstract', 'Minimal', 'Urban'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AppBar(
              backgroundColor: AppColors.background.withValues(alpha: 0.7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {},
              ),
              title: Text(
                'Ethereal',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
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

                          // Featured Card
                          Container(
                            height: 420,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppColors.surfaceContainerLow,
                              boxShadow: AppColors.editorialShadow,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000&auto=format&fit=crop',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 32,
                                  left: 32,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        child: Text(
                                          'FEATURED ARTIST',
                                          style: AppTextStyles.labelLarge
                                              .copyWith(
                                                fontSize: 10,
                                                color: Colors.white,
                                                letterSpacing: 2.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Ethereal Dreams',
                                        style: AppTextStyles.headlineSmall
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Categories
                  SliverToBoxAdapter(
                    child: Column(
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
                              Text(
                                'Explore all',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) => CategoryChip(
                              label: categories[index],
                              isSelected: selectedCategory == categories[index],
                              onTap: () {
                                setState(
                                  () => selectedCategory = categories[index],
                                );
                                if (categories[index] == 'All') {
                                  context
                                      .read<WallpaperCubit>()
                                      .fetchWallpapers();
                                } else {
                                  context
                                      .read<WallpaperCubit>()
                                      .fetchWallpapersByCategory(
                                        categories[index],
                                      );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Gallery Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Trending Now',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  if (state is WallpaperLoaded)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        itemBuilder: (context, index) {
                          return AspectRatio(
                            aspectRatio: 0.75,
                            child: WallpaperGridItem(
                              wallpaper: state.wallpapers[index],
                              onTap: () => context.push(
                                '/preview',
                                extra: state.wallpapers[index],
                              ),
                              isStaggered: index % 2 != 0,
                            ),
                          );
                        },
                        childCount: state.wallpapers.length,
                      ),
                    )
                  else if (state is WallpaperLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  else if (state is WallpaperError)
                    SliverFillRemaining(
                      child: Center(child: Text(state.message)),
                    ),
                ],
              ),

              // Bottom Navigation Bar
              const EtherealBottomBar(activeItem: NavItem.home),
            ],
          );
        },
      ),
    );
  }
}
