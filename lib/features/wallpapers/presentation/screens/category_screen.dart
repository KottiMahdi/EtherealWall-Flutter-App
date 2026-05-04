import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/category_data.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/editorial_collections_grid.dart';
import '../widgets/editorial_wallpaper_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../core/theme/theme_cubit.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category == 'Explore' || widget.category == 'All'
        ? null
        : widget.category;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients && _selectedCategory != null) {
      if (_scrollController.offset > 60 && !_showAppBarTitle) {
        setState(() => _showAppBarTitle = true);
      } else if (_scrollController.offset <= 60 && _showAppBarTitle) {
        setState(() => _showAppBarTitle = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onCategoryTap(BuildContext context, String category) {
    setState(() {
      _selectedCategory = category;
      _showAppBarTitle = false;
    });
    context.read<WallpaperCubit>().fetchWallpapersByCategory(category);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              if (_selectedCategory != null) {
                await context.read<WallpaperCubit>().fetchWallpapersByCategory(
                  _selectedCategory!,
                );
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: _selectedCategory == null ? 120 : 140),
                ),
                if (_selectedCategory == null) ...[
                  _buildHeader(
                    'Explore',
                    'Curated collections for your home screen.',
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
                    sliver: SliverToBoxAdapter(
                      child: EditorialCollectionsGrid(
                        onCategoryTap: (cat) => _onCategoryTap(context, cat),
                      ),
                    ),
                  ),
                ] else ...[
                  _buildHeader(
                    _selectedCategory!,
                    _getCategoryDesc(_selectedCategory!),
                  ),
                  _buildWallpaperGrid(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final bool isTrending = widget.category == 'Trending';
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
            ).colorScheme.surface.withValues(alpha: 0.70),
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  if (_selectedCategory != null && !isTrending) ...[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _showAppBarTitle = false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    if (_showAppBarTitle)
                      Expanded(
                        child: Text(
                          _selectedCategory!,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ] else ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'EtherealWalls',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                color: iconColor,
                onPressed: () {},
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

  Widget _buildWallpaperGrid() {
    return BlocBuilder<WallpaperCubit, WallpaperState>(
      builder: (context, state) {
        if (state is WallpaperLoading) {
          return const SliverFillRemaining(child: EtherealLoading());
        } else if (state is WallpaperError) {
          return SliverFillRemaining(
            child: EtherealError(
              message: state.message,
              onRetry: () => _onCategoryTap(context, _selectedCategory!),
            ),
          );
        } else if (state is WallpaperLoaded) {
          if (state.wallpapers.isEmpty) {
            return const SliverFillRemaining(
              child: EtherealEmpty(
                message: 'No wallpapers found in this category.',
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final wallpaper = state.wallpapers[index];
                return EditorialWallpaperCard(
                  imageUrl: wallpaper.thumbnailUrl,
                  title: wallpaper.title,
                  photographer: wallpaper.photographer,
                  onTap: () => context.push('/preview', extra: wallpaper),
                );
              }, childCount: state.wallpapers.length),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDesc(String name) {
    return allCategories
        .firstWhere((cat) => cat.name == name, orElse: () => allCategories[0])
        .description;
  }
}
