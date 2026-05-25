import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_wallpapers.dart';
import '../../domain/usecases/get_wallpapers_by_category.dart';
import 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  final GetWallpapers getWallpapers;
  final GetWallpapersByCategory getWallpapersByCategory;

  int _currentPage = 1;
  String? _currentQuery;
  bool _isFetching = false;

  WallpaperCubit({
    required this.getWallpapers,
    required this.getWallpapersByCategory,
  }) : super(WallpaperInitial());

  Future<void> fetchWallpapers({int? page, int perPage = 30}) async {
    if (_isFetching) return;
    _isFetching = true;

    emit(WallpaperLoading());

    final targetPage = page ?? (DateTime.now().millisecond % 50) + 1;
    _currentPage = targetPage;
    _currentQuery = null;

    final result = await getWallpapers(
      GetWallpapersParams(page: targetPage, perPage: perPage),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) => emit(WallpaperLoaded(wallpapers: wallpapers)),
    );

    _isFetching = false;
  }

  Future<void> fetchWallpapersByCategory(
    String category, {
    int? page,
    int perPage = 30,
    bool loadMore = false,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    final isSameQuery = category == _currentQuery;
    final currentWallpapers = state is WallpaperLoaded
        ? (state as WallpaperLoaded).wallpapers
        : <Wallpaper>[];

    final targetPage = loadMore && isSameQuery
        ? _currentPage + 1
        : page ?? (DateTime.now().millisecond % 20) + 1;

    if (!loadMore) {
      emit(WallpaperLoading());
    }

    final result = await getWallpapersByCategory(
      GetWallpapersByCategoryParams(
        category: category,
        page: targetPage,
        perPage: perPage,
      ),
    );

    result.fold(
      (failure) => emit(WallpaperError(message: failure.message)),
      (wallpapers) {
        final combinedWallpapers = loadMore && isSameQuery
            ? [...currentWallpapers, ...wallpapers]
            : wallpapers;
        emit(WallpaperLoaded(wallpapers: combinedWallpapers));
        _currentPage = targetPage;
        _currentQuery = category;
      },
    );

    _isFetching = false;
  }
}
