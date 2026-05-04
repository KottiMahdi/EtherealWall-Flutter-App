part of 'download_cubit.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadState {}

class DownloadInProgress extends DownloadState {
  final double progress;
  const DownloadInProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class DownloadSuccess extends DownloadState {
  final String message;
  const DownloadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DownloadFailure extends DownloadState {
  final String error;
  const DownloadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
