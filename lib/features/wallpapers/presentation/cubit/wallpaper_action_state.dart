import 'package:equatable/equatable.dart';

abstract class WallpaperActionState extends Equatable {
  const WallpaperActionState();

  @override
  List<Object?> get props => [];
}

class WallpaperActionInitial extends WallpaperActionState {}

class WallpaperActionLoading extends WallpaperActionState {}

class WallpaperActionSuccess extends WallpaperActionState {
  final String message;
  const WallpaperActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WallpaperActionFailure extends WallpaperActionState {
  final String error;
  const WallpaperActionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
