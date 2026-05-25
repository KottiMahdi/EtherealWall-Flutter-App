import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/wallpapers_masonry_grid.dart';
import '../../../../core/widgets/state_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _query.isEmpty) return;
    if (_scrollController.position.extentAfter < 250) {
      context.read<WallpaperCubit>().fetchWallpapersByCategory(
        _query,
        page: 1,
        loadMore: true,
      );
    }
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _query = query;
    });

    context.read<WallpaperCubit>().fetchWallpapersByCategory(query, page: 1);
    FocusScope.of(context).unfocus();
  }

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
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.7),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _onSearch(),
                        decoration: InputDecoration(
                          hintText: 'Search wallpapers',
                          border: InputBorder.none,
                          hintStyle: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.60),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      onPressed: _onSearch,
                    ),
                  ],
                ),
              ),
              actions: [
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<WallpaperCubit, WallpaperState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              if (_query.isNotEmpty) {
                await context.read<WallpaperCubit>().fetchWallpapersByCategory(
                  _query,
                  page: 1,
                );
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search Wallpapers',
                          style: AppTextStyles.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find wallpapers by keyword, mood, or style.',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (_query.isEmpty) ...[
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Type a search term above to discover wallpapers.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.65),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ] else if (state is WallpaperLoading) ...[
                  const SliverFillRemaining(child: EtherealLoading()),
                ] else if (state is WallpaperError) ...[
                  SliverFillRemaining(
                    child: EtherealError(
                      message: state.message,
                      onRetry: _onSearch,
                    ),
                  ),
                ] else if (state is WallpaperLoaded) ...[
                  if (state.wallpapers.isEmpty)
                    const SliverFillRemaining(
                      child: EtherealEmpty(
                        message: 'No wallpapers matched your search.',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      sliver: WallpapersMasonryGrid(
                        wallpapers: state.wallpapers,
                      ),
                    ),
                ] else ...[
                  const SliverFillRemaining(child: EtherealLoading()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
