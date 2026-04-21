import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/wallpaper.dart';
import '../cubit/favorites_cubit.dart';

class PreviewScreen extends StatelessWidget {
  final Wallpaper wallpaper;

  const PreviewScreen({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen Image
          CachedNetworkImage(
            imageUrl: wallpaper.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 64),
            ),
          ),

          // Subtle Darkening Overlays
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Top Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).padding.top + 8,
                    24,
                    16,
                  ),
                  color: const Color(0xFFFAF9FE).withValues(alpha: 0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderIcon(
                        Icons.arrow_back_rounded,
                        () => context.pop(),
                      ),
                      Column(
                        children: [
                          Text(
                            'ETHEREAL',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'PREMIUM ART',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      _buildHeaderIcon(Icons.more_vert_rounded, () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Info Section
          Positioned(
            bottom: 160,
            left: 32,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallpaper.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: AppColors.editorialShadow,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          bool isFavorite = false;
                          if (state is FavoritesLoaded) {
                            isFavorite = state.favorites.any(
                              (e) => e.id == wallpaper.id,
                            );
                          }
                          return _buildActionIcon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.red : null,
                            onTap: () {
                              context
                                  .read<FavoritesCubit>()
                                  .toggleWallpaperFavorite(wallpaper);
                            },
                          );
                        },
                      ),
                      _buildActionIcon(
                        Icons.download_rounded,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Download feature coming soon!"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Setting wallpaper coming soon!"),
                            ),
                          ),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wallpaper_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Set Wallpaper',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildActionIcon(
                        Icons.share_rounded,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Share feature coming soon!"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }


  Widget _buildActionIcon(IconData icon, {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: color ?? AppColors.onSurfaceVariant),
      ),
    );
  }
}
