import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperDownloadService {
  final Dio _dio;

  WallpaperDownloadService(this._dio);

  /// Downloads a wallpaper from [url] and saves it to the device storage.
  /// [fileName] should include the extension (e.g., 'wallpaper.jpg').
  /// [onProgress] provides the download progress as a double between 0.0 and 1.0.
  Future<void> downloadWallpaper({
    required String url,
    required String fileName,
    required Function(double progress) onProgress,
    required Function(String message) onSuccess,
    required Function(String error) onFailure,
  }) async {
    try {
      // 1. Check/Request Permissions using Gal
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          onFailure('Permission to access gallery was denied.');
          return;
        }
      }

      // 2. Prepare temp path
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      // 3. Download the file using Dio
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            onProgress(count / total);
          }
        },
      );

      // 4. Save to gallery using Gal
      await Gal.putImage(filePath);

      // 5. Clean up temp file
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      onSuccess('Wallpaper saved to gallery successfully!');
    } on DioException catch (e) {
      onFailure('Download failed: ${e.message ?? 'Unknown network error'}');
    } catch (e) {
      onFailure('An unexpected error occurred: ${e.toString()}');
    }
  }
}
