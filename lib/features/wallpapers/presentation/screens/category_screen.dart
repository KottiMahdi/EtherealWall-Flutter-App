import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/ethereal_bottom_bar.dart';
import '../../../../core/di/injection_container.dart';

// ─── Categories Data ──────────────────────────────────────────────────────────
class CategoryData {
  final String name;
  final String description;
  final String imageUrl;
  final String count;

  const CategoryData({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.count,
  });
}

const _allCategories = [
  CategoryData(
    name: 'Abstract',
    description: 'Fluid dynamics and digital dreamscapes.',
    imageUrl: 'https://images.pexels.com/photos/2832382/pexels-photo-2832382.jpeg',
    count: '1.2k',
  ),
  CategoryData(
    name: 'Nature',
    description: 'Breathtaking landscapes.',
    imageUrl: 'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg',
    count: '2.1k',
  ),
  CategoryData(
    name: 'Minimal',
    description: 'Clean restful tones.',
    imageUrl: 'https://images.pexels.com/photos/3124111/pexels-photo-3124111.jpeg',
    count: '850',
  ),
  CategoryData(
    name: 'Urban',
    description: 'Architecture & city rhythms.',
    imageUrl: 'https://images.pexels.com/photos/210186/pexels-photo-210186.jpeg',
    count: '1.1k',
  ),
  CategoryData(
    name: 'Space',
    description: 'Cosmic celestial art.',
    imageUrl: 'https://images.pexels.com/photos/41951/earth-planet-world-continents-41951.jpeg',
    count: '640',
  ),
  CategoryData(
    name: 'Cinematic',
    description: 'Dramatic lighting.',
    imageUrl: 'https://images.pexels.com/photos/2440024/pexels-photo-2440024.jpeg',
    count: '930',
  ),
];


class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Special handling for Trending and user-selected categories
    _selectedCategory = widget.category == 'Explore' || widget.category == 'All' 
        ? null 
        : widget.category;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategoryTap(BuildContext context, String category) {
    setState(() {
      _selectedCategory = category;
    });
    context.read<WallpaperCubit>().fetchWallpapersByCategory(category);
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _clearSelection() {
    setState(() {
      _selectedCategory = null;
    });
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<WallpaperCubit>();
        if (_selectedCategory != null) {
          cubit.fetchWallpapersByCategory(_selectedCategory!);
        }
        return cubit;
      },
      child: Builder(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(68),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppBar(
                  backgroundColor: AppColors.background.withValues(alpha: 0.70),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(_selectedCategory == null
                              ? Icons.arrow_back_ios_new_rounded
                              : Icons.close_rounded),
                          color: AppColors.primary,
                          onPressed: () {
                            if (_selectedCategory == null) {
                              context.go('/');
                            } else {
                              _clearSelection();
                            }
                          },
                        ),
                        Text(
                          _selectedCategory ?? 'Ethereal',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      color: AppColors.primary,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  if (_selectedCategory == null) ...[
                    _buildHeader('Explore', 'Curated collections for your home screen.'),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
                      sliver: SliverToBoxAdapter(
                        child: _EditorialCollectionsGrid(
                          onCategoryTap: (cat) => _onCategoryTap(context, cat),
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildHeader(_selectedCategory!, _getCategoryDesc(_selectedCategory!)),
                    BlocBuilder<WallpaperCubit, WallpaperState>(
                      builder: (context, state) {
                        if (state is WallpaperLoading) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator.adaptive()),
                          );
                        } else if (state is WallpaperError) {
                          return SliverFillRemaining(
                            child: Center(child: Text(state.message)),
                          );
                        } else if (state is WallpaperLoaded) {
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.65,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final wallpaper = state.wallpapers[index];
                                  return _EditorialWallpaperCard(
                                    imageUrl: wallpaper.thumbnailUrl,
                                    title: wallpaper.title,
                                    photographer: wallpaper.photographer,
                                    onTap: () => context.push('/preview', extra: wallpaper),
                                  );
                                },
                                childCount: state.wallpapers.length,
                              ),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      },
                    ),
                  ],
                ],
              ),
              EtherealBottomBar(
                activeItem: widget.category == 'Trending'
                    ? NavItem.trending
                    : NavItem.browse,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDesc(String name) {
    return _allCategories.firstWhere((cat) => cat.name == name, orElse: () => _allCategories[0]).description;
  }
}

// ─── Editorial Wallpaper Card ─────────────────────────────────────────────────
class _EditorialWallpaperCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String photographer;
  final VoidCallback onTap;

  const _EditorialWallpaperCard({
    required this.imageUrl,
    required this.title,
    required this.photographer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.surfaceContainerHigh),
            ),
            // Bottom Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    photographer,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Editorial Collections Grid (internal component) ──────────────────────────
class _EditorialCollectionsGrid extends StatelessWidget {
  final void Function(String category) onCategoryTap;
  const _EditorialCollectionsGrid({required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard(_allCategories[0], 1.5),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildCard(_allCategories[1], 0.85)),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: _buildCard(_allCategories[2], 0.85),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildCard(_allCategories[3], 2.2),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: _buildCard(_allCategories[4], 0.85),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: _buildCard(_allCategories[5], 0.85)),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(CategoryData cat, double ratio) {
    return _CategoryCard(
      category: cat,
      aspectRatio: ratio,
      onTap: () => onCategoryTap(cat.name),
    );
  }
}

// ─── Refined Category Card (reused from previous turns) ────────────────────────
class _CategoryCard extends StatefulWidget {
  final CategoryData category;
  final double aspectRatio;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.aspectRatio,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.category.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.surfaceContainerHigh),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: const [0.0, 0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              '${widget.category.count} ITEMS',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.category.name,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: widget.aspectRatio > 1.2 ? 32 : 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
