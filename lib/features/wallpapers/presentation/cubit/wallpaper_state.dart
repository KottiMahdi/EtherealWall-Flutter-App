import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper.dart';

const Object _unsetLoadMoreError = Object();

abstract class WallpaperState extends Equatable {
  const WallpaperState();

  @override
  List<Object?> get props => [];
}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<Wallpaper> wallpapers;
  final bool isLoadingMore;
  final bool hasMore;
  final String? loadMoreError;

  const WallpaperLoaded({
    required this.wallpapers,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.loadMoreError,
  });

  WallpaperLoaded copyWith({
    List<Wallpaper>? wallpapers,
    bool? isLoadingMore,
    bool? hasMore,
    Object? loadMoreError = _unsetLoadMoreError,
  }) {
    return WallpaperLoaded(
      wallpapers: wallpapers ?? this.wallpapers,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loadMoreError: identical(loadMoreError, _unsetLoadMoreError)
          ? this.loadMoreError
          : loadMoreError as String?,
    );
  }

  @override
  List<Object?> get props => [
    wallpapers,
    isLoadingMore,
    hasMore,
    loadMoreError,
  ];
}

class WallpaperError extends WallpaperState {
  final String message;

  const WallpaperError({required this.message});

  @override
  List<Object?> get props => [message];
}
