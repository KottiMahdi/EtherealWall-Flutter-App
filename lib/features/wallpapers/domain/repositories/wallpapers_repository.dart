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
}
