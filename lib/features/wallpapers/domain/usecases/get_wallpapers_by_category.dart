import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wallpaper.dart';
import '../repositories/wallpapers_repository.dart';

class GetWallpapersByCategory
    implements UseCase<List<Wallpaper>, GetWallpapersByCategoryParams> {
  final WallpapersRepository repository;

  const GetWallpapersByCategory(this.repository);

  @override
  Future<Either<Failure, List<Wallpaper>>> call(
    GetWallpapersByCategoryParams params,
  ) async {
    return repository.getWallpapersByCategory(
      category: params.category,
      page: params.page,
      perPage: params.perPage,
    );
  }
}

class GetWallpapersByCategoryParams extends Equatable {
  final String category;
  final int page;
  final int perPage;

  const GetWallpapersByCategoryParams({
    required this.category,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object> get props => [category, page, perPage];
}
