import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/wallpaper.dart';
import 'wallpaper_grid_item.dart';

class WallpapersMasonryGrid extends StatelessWidget {
  final List<Wallpaper> wallpapers;

  const WallpapersMasonryGrid({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 0.75,
            child: WallpaperGridItem(
              wallpaper: wallpapers[index],
              onTap: () => context.push(
                '/preview',
                extra: wallpapers[index],
              ),
              isStaggered: index % 2 != 0,
            ),
          );
        },
        childCount: wallpapers.length,
      ),
    );
  }
}
