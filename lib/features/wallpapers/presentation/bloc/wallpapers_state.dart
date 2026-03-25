part of 'wallpapers_bloc.dart';

abstract class WallpapersState extends Equatable {
  const WallpapersState();
  @override
  List<Object> get props => [];
}

class WallpapersInitial extends WallpapersState {}

class WallpapersLoading extends WallpapersState {}

class WallpapersLoaded extends WallpapersState {
  final List<Wallpaper> wallpapers;
  const WallpapersLoaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class WallpapersError extends WallpapersState {
  final String message;
  const WallpapersError({required this.message});

  @override
  List<Object> get props => [message];
}
