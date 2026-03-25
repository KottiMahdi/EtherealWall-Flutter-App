import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallpaper.dart';
import '../../domain/usecases/get_wallpapers.dart';

part 'wallpapers_event.dart';
part 'wallpapers_state.dart';

class WallpapersBloc extends Bloc<WallpapersEvent, WallpapersState> {
  final GetWallpapers getWallpapers;

  WallpapersBloc({required this.getWallpapers})
      : super(WallpapersInitial()) {
    on<FetchWallpapersEvent>(_onFetchWallpapers);
  }

  Future<void> _onFetchWallpapers(
    FetchWallpapersEvent event,
    Emitter<WallpapersState> emit,
  ) async {
    emit(WallpapersLoading());

    final result = await getWallpapers(
      GetWallpapersParams(page: event.page, perPage: event.perPage),
    );

    result.fold(
      (failure) => emit(WallpapersError(message: _mapFailureToMessage(failure))),
      (wallpapers) => emit(WallpapersLoaded(wallpapers: wallpapers)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => 'Server error: ${failure.message}',
      NetworkFailure() => 'No internet connection.',
      CacheFailure() => 'Cache error: ${failure.message}',
      _ => 'Unexpected error.',
    };
  }
}
