import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/wallpaper_cubit.dart';
import '../cubit/wallpaper_state.dart';
import '../widgets/wallpaper_grid_item.dart';
import '../widgets/ethereal_bottom_bar.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Trigger category fetch upon build
    context.read<WallpaperCubit>().fetchWallpapersByCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category, style: AppTextStyles.headlineSmall),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          BlocBuilder<WallpaperCubit, WallpaperState>(
            builder: (context, state) {
              if (state is WallpaperLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is WallpaperError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context
                              .read<WallpaperCubit>()
                              .fetchWallpapersByCategory(category),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is WallpaperLoaded) {
                if (state.wallpapers.isEmpty) {
                  return const Center(
                    child: Text('No wallpapers found in this category.'),
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
                  itemCount: state.wallpapers.length,
                  itemBuilder: (context, index) => WallpaperGridItem(
                    wallpaper: state.wallpapers[index],
                    onTap: () => context.push(
                      '/preview',
                      extra: state.wallpapers[index],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const EtherealBottomBar(activeItem: NavItem.browse),
        ],
      ),
    );
  }
}
