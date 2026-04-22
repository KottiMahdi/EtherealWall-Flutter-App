import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/wallpaper.dart';
import '../cubit/favorites_cubit.dart';

class WallpaperGridItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;
  final bool isStaggered;

  const WallpaperGridItem({
    super.key,
    required this.wallpaper,
    required this.onTap,
    this.isStaggered = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: isStaggered ? 32 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  16,
                ), // 'lg' in design is 32px, but let's use 16px as in standard rounded-lg
                color: AppColors.surfaceContainerLow,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: wallpaper.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.surfaceContainerHighest),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceContainerHighest,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_rounded,
                              size: 32,
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        bool isFavorite = false;
                        if (state is FavoritesLoaded) {
                          isFavorite = state.favorites.any((f) => f.id == wallpaper.id);
                        }
                        
                        return GestureDetector(
                          onTap: () {
                            context.read<FavoritesCubit>().toggleWallpaperFavorite(wallpaper);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            wallpaper.title,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            wallpaper.photographer,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
