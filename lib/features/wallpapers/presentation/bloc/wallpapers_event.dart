part of 'wallpapers_bloc.dart';

abstract class WallpapersEvent extends Equatable {
  const WallpapersEvent();
  @override
  List<Object> get props => [];
}

class FetchWallpapersEvent extends WallpapersEvent {
  final int page;
  final int perPage;

  const FetchWallpapersEvent({this.page = 1, this.perPage = 20});

  @override
  List<Object> get props => [page, perPage];
}
