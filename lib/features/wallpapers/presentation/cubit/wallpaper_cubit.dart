import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wallpapers.dart';
import '../../domain/usecases/get_wallpapers_by_category.dart';
import 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  final GetWallpapers getWallpapers;
  final GetWallpapersByCategory getWallpapersByCategory;

  WallpaperCubit({
    required this.getWallpapers,
    required this.getWallpapersByCategory,
  }) : super(WallpaperInitial());

  Future<void> fetchWallpapers({int? page, int perPage = 30}) async {
    emit(WallpaperLoading());

    // Randomize page on refresh to bring "latest" and fresh variety
    final targetPage = page ?? (DateTime.now().millisecond % 50) + 1;

    final result = await getWallpapers(
      GetWallpapersParams(page: targetPage, perPage: perPage),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) => emit(WallpaperLoaded(wallpapers: wallpapers)),
    );
  }

  Future<void> fetchWallpapersByCategory(
    String category, {
    int? page,
    int perPage = 30,
  }) async {
    emit(WallpaperLoading());

    // Randomize page on category refresh for variety
    final targetPage = page ?? (DateTime.now().millisecond % 20) + 1;

    final result = await getWallpapersByCategory(
      GetWallpapersByCategoryParams(
        category: category,
        page: targetPage,
        perPage: perPage,
      ),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) => emit(WallpaperLoaded(wallpapers: wallpapers)),
    );
  }
}
