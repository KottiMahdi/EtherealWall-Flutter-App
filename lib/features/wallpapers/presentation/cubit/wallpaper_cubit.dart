import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_wallpapers.dart';
import '../../domain/usecases/get_wallpapers_by_category.dart';
import 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  static const int _randomCuratedPageWindow = 50;
  static const int _randomCategoryPageWindow = 20;

  final GetWallpapers getWallpapers;
  final GetWallpapersByCategory getWallpapersByCategory;

  int _currentPage = 0;
  String? _currentQuery;
  bool _isFetching = false;

  WallpaperCubit({
    required this.getWallpapers,
    required this.getWallpapersByCategory,
  }) : super(WallpaperInitial());

  Future<void> fetchWallpapers({
    int? page,
    int perPage = 30,
    bool loadMore = false,
  }) async {
    final loadedState = state is WallpaperLoaded
        ? state as WallpaperLoaded
        : null;
    if (loadMore && loadedState?.hasMore == false) return;
    if (_isFetching) return;
    _isFetching = true;

    final currentWallpapers = loadMore && _currentQuery == null
        ? loadedState?.wallpapers ?? <Wallpaper>[]
        : <Wallpaper>[];

    final targetPage = loadMore && _currentQuery == null
        ? _currentPage + 1
        : page ?? _randomPage(_randomCuratedPageWindow);

    if (loadMore && loadedState != null && _currentQuery == null) {
      emit(loadedState.copyWith(isLoadingMore: true, loadMoreError: null));
    } else {
      emit(WallpaperLoading());
    }

    try {
      final result = await getWallpapers(
        GetWallpapersParams(page: targetPage, perPage: perPage),
      );

      if (isClosed) return;

      result.fold(
        (failure) {
          if (loadMore && currentWallpapers.isNotEmpty) {
            emit(
              WallpaperLoaded(
                wallpapers: currentWallpapers,
                hasMore: loadedState?.hasMore ?? true,
                loadMoreError: failure.message,
              ),
            );
          } else {
            emit(WallpaperError(message: failure.message));
          }
        },
        (wallpapers) {
          final combinedWallpapers = loadMore
              ? _appendUnique(currentWallpapers, wallpapers)
              : wallpapers;
          emit(
            WallpaperLoaded(
              wallpapers: combinedWallpapers,
              hasMore: wallpapers.length >= perPage,
            ),
          );
          _currentPage = targetPage;
          _currentQuery = null;
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> fetchWallpapersByCategory(
    String category, {
    int? page,
    int perPage = 30,
    bool loadMore = false,
  }) async {
    final loadedState = state is WallpaperLoaded
        ? state as WallpaperLoaded
        : null;
    final isSameQuery = category == _currentQuery;
    if (loadMore && isSameQuery && loadedState?.hasMore == false) return;
    if (_isFetching) return;
    _isFetching = true;

    final currentWallpapers = loadMore && isSameQuery
        ? loadedState?.wallpapers ?? <Wallpaper>[]
        : <Wallpaper>[];

    final targetPage = loadMore && isSameQuery
        ? _currentPage + 1
        : page ?? _randomPage(_randomCategoryPageWindow);

    if (loadMore && isSameQuery && loadedState != null) {
      emit(loadedState.copyWith(isLoadingMore: true, loadMoreError: null));
    } else {
      emit(WallpaperLoading());
    }

    try {
      final result = await getWallpapersByCategory(
        GetWallpapersByCategoryParams(
          category: category,
          page: targetPage,
          perPage: perPage,
        ),
      );

      if (isClosed) return;

      result.fold(
        (failure) {
          if (loadMore && currentWallpapers.isNotEmpty) {
            emit(
              WallpaperLoaded(
                wallpapers: currentWallpapers,
                hasMore: loadedState?.hasMore ?? true,
                loadMoreError: failure.message,
              ),
            );
          } else {
            emit(WallpaperError(message: failure.message));
          }
        },
        (wallpapers) {
          final combinedWallpapers = loadMore && isSameQuery
              ? _appendUnique(currentWallpapers, wallpapers)
              : wallpapers;
          emit(
            WallpaperLoaded(
              wallpapers: combinedWallpapers,
              hasMore: wallpapers.length >= perPage,
            ),
          );
          _currentPage = targetPage;
          _currentQuery = category;
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  int _randomPage(int pageWindow) {
    return (DateTime.now().millisecondsSinceEpoch % pageWindow) + 1;
  }

  List<Wallpaper> _appendUnique(
    List<Wallpaper> currentWallpapers,
    List<Wallpaper> newWallpapers,
  ) {
    final existingIds = currentWallpapers
        .map((wallpaper) => wallpaper.id)
        .toSet();
    return [
      ...currentWallpapers,
      for (final wallpaper in newWallpapers)
        if (existingIds.add(wallpaper.id)) wallpaper,
    ];
  }
}
