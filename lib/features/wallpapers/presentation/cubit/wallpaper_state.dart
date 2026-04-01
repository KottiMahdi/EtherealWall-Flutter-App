import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper.dart';

abstract class WallpaperState extends Equatable {
  const WallpaperState();

  @override
  List<Object?> get props => [];
}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<Wallpaper> wallpapers;

  const WallpaperLoaded({required this.wallpapers});

  @override
  List<Object?> get props => [wallpapers];
}

class WallpaperError extends WallpaperState {
  final String message;

  const WallpaperError({required this.message});

  @override
  List<Object?> get props => [message];
}
