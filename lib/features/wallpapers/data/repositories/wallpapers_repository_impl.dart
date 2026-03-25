import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/repositories/wallpapers_repository.dart';
import '../datasources/wallpapers_remote_data_source.dart';

class WallpapersRepositoryImpl implements WallpapersRepository {
  final WallpapersRemoteDataSource remoteDataSource;

  WallpapersRepositoryImpl({required this.remoteDataSource});

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
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Wallpaper>> getWallpaperById(String id) async {
    try {
      final result = await remoteDataSource.getWallpaperById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
