import 'dart:io';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

enum WallpaperTargetType {
  home,
  lock,
  both,
}

class WallpaperActionService {
  final Dio _dio;

  WallpaperActionService(this._dio);

  Future<bool> setWallpaper({
    required String imageUrl,
    required WallpaperTargetType target,
  }) async {
    File? tempFile;
    try {
      final int location;
      switch (target) {
        case WallpaperTargetType.home:
          location = AsyncWallpaper.HOME_SCREEN;
          break;
        case WallpaperTargetType.lock:
          location = AsyncWallpaper.LOCK_SCREEN;
          break;
        case WallpaperTargetType.both:
          location = AsyncWallpaper.BOTH_SCREENS;
          break;
      }

      // Download manually to avoid system activity restarts
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _dio.download(imageUrl, tempPath);
      tempFile = File(tempPath);

      final bool result;
      if (target == WallpaperTargetType.both) {
        // Set home first
        await AsyncWallpaper.setWallpaperFromFile(
          filePath: tempFile.path,
          wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
          goToHome: false,
        );
        // Small delay to let system breathe
        await Future.delayed(const Duration(milliseconds: 200));
        // Set lock screen
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: tempFile.path,
          wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
          goToHome: false,
        );
      } else {
        result = await AsyncWallpaper.setWallpaperFromFile(
          filePath: tempFile.path,
          wallpaperLocation: location,
          goToHome: false,
        );
      }

      return result;
    } catch (e) {
      debugPrint('Error setting wallpaper: $e');
      return false;
    } finally {
      // Clean up temp file immediately
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }
}
