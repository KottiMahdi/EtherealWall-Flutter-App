import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/repositories/wallpapers_repository.dart';
import '../datasources/wallpapers_local_data_source.dart';
import '../datasources/wallpapers_remote_data_source.dart';
import '../models/wallpaper_model.dart';

class WallpapersRepositoryImpl implements WallpapersRepository {
  final WallpapersRemoteDataSource remoteDataSource;
  final WallpapersLocalDataSource localDataSource;

  WallpapersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Wallpaper>>> getWallpapers({
    required int page,
    required int perPage,
  }) async {
    try {
      final result = await remoteDataSource.getWallpapers(
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallpaper>> getWallpaperById(String id) async {
    try {
      final result = await remoteDataSource.getWallpaperById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Wallpaper>>> getWallpapersByCategory({
    required String category,
    required int page,
    required int perPage,
  }) async {
    try {
      final result = await remoteDataSource.getWallpapersByCategory(
        category: category,
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveFavorite(Wallpaper wallpaper) async {
    try {
      final model = WallpaperModel(
        id: wallpaper.id,
        title: wallpaper.title,
        imageUrl: wallpaper.imageUrl,
        thumbnailUrl: wallpaper.thumbnailUrl,
        category: wallpaper.category,
        photographer: wallpaper.photographer,
        width: wallpaper.width,
        height: wallpaper.height,
      );
      await localDataSource.saveFavorite(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String id) async {
    try {
      await localDataSource.removeFavorite(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Wallpaper>>> getFavorites() async {
    try {
      final result = await localDataSource.getFavorites();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String id) async {
    try {
      final result = await localDataSource.isFavorite(id);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
