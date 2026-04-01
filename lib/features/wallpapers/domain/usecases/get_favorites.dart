import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpapers_repository.dart';

class GetFavorites implements UseCase<List<Wallpaper>, NoParams> {
  final WallpapersRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<Wallpaper>>> call(NoParams params) async {
    return repository.getFavorites();
  }
}
