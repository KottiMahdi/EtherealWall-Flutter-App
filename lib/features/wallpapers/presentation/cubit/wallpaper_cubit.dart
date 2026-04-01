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

  Future<void> fetchWallpapers({int page = 1, int perPage = 20}) async {
    emit(WallpaperLoading());

    final result = await getWallpapers(
      GetWallpapersParams(page: page, perPage: perPage),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) => emit(WallpaperLoaded(wallpapers: wallpapers)),
    );
  }

  Future<void> fetchWallpapersByCategory(
    String category, {
    int page = 1,
    int perPage = 20,
  }) async {
    emit(WallpaperLoading());

    final result = await getWallpapersByCategory(
      GetWallpapersByCategoryParams(
        category: category,
        page: page,
        perPage: perPage,
      ),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) => emit(WallpaperLoaded(wallpapers: wallpapers)),
    );
  }
}
