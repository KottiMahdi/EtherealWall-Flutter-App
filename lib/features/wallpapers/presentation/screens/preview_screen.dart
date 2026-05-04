import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/wallpaper.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/download_cubit.dart';
import '../cubit/wallpaper_action_cubit.dart';
import '../cubit/wallpaper_action_state.dart';
import '../../data/services/wallpaper_action_service.dart';
import '../../../../core/di/injection_container.dart';

class PreviewScreen extends StatelessWidget {
  final Wallpaper wallpaper;

  const PreviewScreen({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<DownloadCubit>()),
        BlocProvider(create: (context) => sl<WallpaperActionCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DownloadCubit, DownloadState>(
            listener: (context, state) {
              if (state is DownloadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is DownloadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          BlocListener<WallpaperActionCubit, WallpaperActionState>(
            listener: (context, state) {
              if (state is WallpaperActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is WallpaperActionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, state) {
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
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
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20,
                  child: _buildHeaderIcon(
                    Icons.arrow_back_rounded,
                    () => context.pop(),
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
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
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
                                  context,
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
                            _buildDownloadButton(context, state),
                            const SizedBox(width: 8),
                            Expanded(
                                child: BlocBuilder<WallpaperActionCubit,
                                    WallpaperActionState>(
                                  builder: (context, actionState) {
                                    return GestureDetector(
                                      onTap: actionState
                                              is WallpaperActionLoading
                                          ? null
                                          : () => _showWallpaperSelection(
                                              context, wallpaper),
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppColors.primary.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: actionState
                                                  is WallpaperActionLoading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.wallpaper_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Flexible(
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 16,
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ),
                            _buildActionIcon(
                              context,
                              Icons.share_rounded,
                              onTap: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Share feature coming soon!",
                                      ),
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
        },
      ),
    ),
  );
}

  Widget _buildDownloadButton(BuildContext context, DownloadState state) {
    if (state is DownloadInProgress) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: state.progress,
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          ),
        ),
      );
    }

    return _buildActionIcon(
      context,
      Icons.download_rounded,
      onTap: () {
        context.read<DownloadCubit>().downloadWallpaper(
          wallpaper.imageUrl,
          wallpaper.title,
        );
      },
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

  void _showWallpaperSelection(BuildContext context, Wallpaper wallpaper) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Set Wallpaper',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            _buildSelectionTile(
              context,
              icon: Icons.home_rounded,
              title: 'Home Screen',
              onTap: () {
                Navigator.pop(bottomSheetContext);
                context.read<WallpaperActionCubit>().setWallpaper(
                      imageUrl: wallpaper.imageUrl,
                      target: WallpaperTargetType.home,
                    );
              },
            ),
            _buildSelectionTile(
              context,
              icon: Icons.lock_rounded,
              title: 'Lock Screen',
              onTap: () {
                Navigator.pop(bottomSheetContext);
                context.read<WallpaperActionCubit>().setWallpaper(
                      imageUrl: wallpaper.imageUrl,
                      target: WallpaperTargetType.lock,
                    );
              },
            ),
            _buildSelectionTile(
              context,
              icon: Icons.phonelink_setup_rounded,
              title: 'Both Screens',
              onTap: () {
                Navigator.pop(bottomSheetContext);
                context.read<WallpaperActionCubit>().setWallpaper(
                      imageUrl: wallpaper.imageUrl,
                      target: WallpaperTargetType.both,
                    );
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }

  Widget _buildActionIcon(BuildContext context, IconData icon, {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: color ?? Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
