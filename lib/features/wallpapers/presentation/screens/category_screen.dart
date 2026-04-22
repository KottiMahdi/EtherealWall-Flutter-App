import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/category_data.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/editorial_collections_grid.dart';
import '../widgets/editorial_wallpaper_card.dart';
import '../../../../core/widgets/state_widgets.dart';

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
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
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
    return PreferredSize(
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
                  const SizedBox(width: 24),
                  Text(
                    'EtherealWalls',
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
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0,
              ),
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
