import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpapers_repository.dart';

class GetWallpapers implements UseCase<List<Wallpaper>, GetWallpapersParams> {
  final WallpapersRepository repository;

  const GetWallpapers(this.repository);

  @override
  Future<Either<Failure, List<Wallpaper>>> call(
      GetWallpapersParams params) async {
    return repository.getWallpapers(
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class GetWallpapersParams {
  final int page;
  final int perPage;

  const GetWallpapersParams({this.page = 1, this.perPage = 20});
}
