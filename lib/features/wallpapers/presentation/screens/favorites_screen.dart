import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/favorites_cubit.dart';
import '../widgets/wallpaper_grid_item.dart';
import '../widgets/ethereal_bottom_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Refresh favorites when this screen is opened
    context.read<FavoritesCubit>().loadFavorites();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: AppTextStyles.headlineSmall),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is FavoritesError) {
                return Center(child: Text(state.message));
              } else if (state is FavoritesLoaded) {
                if (state.favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 64,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Wallpapers you love will appear here.',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) => WallpaperGridItem(
                    wallpaper: state.favorites[index],
                    onTap: () =>
                        context.push('/preview', extra: state.favorites[index]),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const EtherealBottomBar(activeItem: NavItem.favorites),
        ],
      ),
    );
  }
}
