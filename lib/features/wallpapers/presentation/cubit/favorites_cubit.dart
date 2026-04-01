import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/wallpapers_repository.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Wallpaper> favorites;
  const FavoritesLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;
  final WallpapersRepository repository; // Added for isFavorite check

  FavoritesCubit({
    required this.getFavorites,
    required this.toggleFavorite,
    required this.repository,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final result = await getFavorites(NoParams());
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> toggleWallpaperFavorite(Wallpaper wallpaper) async {
    final result = await toggleFavorite(wallpaper);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => loadFavorites(),
    );
  }

  Future<bool> isWallpaperFavorite(String id) async {
    final result = await repository.isFavorite(id);
    return result.fold((_) => false, (isFav) => isFav);
  }
}
