import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/wallpaper.dart';

abstract class WallpapersRepository {
  /// Fetch a paginated list of wallpapers.
  Future<Either<Failure, List<Wallpaper>>> getWallpapers({
    required int page,
    required int perPage,
  });

  /// Fetch a single wallpaper by [id].
  Future<Either<Failure, Wallpaper>> getWallpaperById(String id);

  /// Fetch wallpapers by [category].
  Future<Either<Failure, List<Wallpaper>>> getWallpapersByCategory({
    required String category,
    required int page,
    required int perPage,
  });

  /// Manage Favorites
  Future<Either<Failure, void>> saveFavorite(Wallpaper wallpaper);
  Future<Either<Failure, void>> removeFavorite(String id);
  Future<Either<Failure, List<Wallpaper>>> getFavorites();
  Future<Either<Failure, bool>> isFavorite(String id);
}
