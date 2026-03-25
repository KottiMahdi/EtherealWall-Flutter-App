import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpapers_repository.dart';

class GetWallpaperById implements UseCase<Wallpaper, String> {
  final WallpapersRepository repository;

  const GetWallpaperById(this.repository);

  @override
  Future<Either<Failure, Wallpaper>> call(String id) async {
    return repository.getWallpaperById(id);
  }
}
