import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpapers_repository.dart';

class ToggleFavorite implements UseCase<void, Wallpaper> {
  final WallpapersRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(Wallpaper wallpaper) async {
    final isFavResult = await repository.isFavorite(wallpaper.id);

    return isFavResult.fold((failure) => Left(failure), (isFavorite) async {
      if (isFavorite) {
        return repository.removeFavorite(wallpaper.id);
      } else {
        return repository.saveFavorite(wallpaper);
      }
    });
  }
}
