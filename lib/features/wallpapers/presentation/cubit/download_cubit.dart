import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/services/wallpaper_download_service.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  final WallpaperDownloadService _downloadService;

  DownloadCubit(this._downloadService) : super(DownloadInitial());

  Future<void> downloadWallpaper(String url, String title) async {
    // Sanitize title for filename
    final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s\-]'), '').replaceAll(' ', '_');
    final fileName = '${sanitizedTitle}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    emit(const DownloadInProgress(0.0));

    await _downloadService.downloadWallpaper(
      url: url,
      fileName: fileName,
      onProgress: (progress) {
        if (!isClosed) emit(DownloadInProgress(progress));
      },
      onSuccess: (message) {
        if (!isClosed) emit(DownloadSuccess(message));
      },
      onFailure: (error) {
        if (!isClosed) emit(DownloadFailure(error));
      },
    );
  }

  void reset() {
    emit(DownloadInitial());
  }
}
