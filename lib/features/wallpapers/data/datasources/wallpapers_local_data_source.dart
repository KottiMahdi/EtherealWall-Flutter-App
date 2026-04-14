import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/wallpaper_model.dart';

abstract class WallpapersLocalDataSource {
  Future<void> saveFavorite(WallpaperModel wallpaper);
  Future<void> removeFavorite(String id);
  Future<List<WallpaperModel>> getFavorites();
  Future<bool> isFavorite(String id);
}

class WallpapersLocalDataSourceImpl implements WallpapersLocalDataSource {
  static const String _boxName = 'favorites_box';

  WallpapersLocalDataSourceImpl();

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> saveFavorite(WallpaperModel wallpaper) async {
    try {
      final box = await _getBox();
      await box.put(wallpaper.id, wallpaper.toJson());
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<WallpaperModel>> getFavorites() async {
    try {
      final box = await _getBox();
      return box.values
          .map((e) => WallpaperModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    final box = await _getBox();
    return box.containsKey(id);
  }
}
