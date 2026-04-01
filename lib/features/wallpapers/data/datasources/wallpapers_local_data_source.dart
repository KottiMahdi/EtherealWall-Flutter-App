import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/wallpaper_model.dart';

abstract class WallpapersLocalDataSource {
  Future<void> saveFavorite(WallpaperModel wallpaper);
  Future<void> removeFavorite(String id);
  Future<List<WallpaperModel>> getFavorites();
  Future<bool> isFavorite(String id);
}

class WallpapersLocalDataSourceImpl implements WallpapersLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'favorite_wallpapers';

  WallpapersLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveFavorite(WallpaperModel wallpaper) async {
    try {
      final List<WallpaperModel> favorites = await getFavorites();

      // Update or add the wallpaper
      final index = favorites.indexWhere(
        (element) => element.id == wallpaper.id,
      );
      if (index != -1) {
        favorites[index] = wallpaper;
      } else {
        favorites.add(wallpaper);
      }

      await _persist(favorites);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    try {
      final List<WallpaperModel> favorites = await getFavorites();
      favorites.removeWhere((element) => element.id == id);
      await _persist(favorites);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<WallpaperModel>> getFavorites() async {
    final String? jsonString = sharedPreferences.getString(_favoritesKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List list = json.decode(jsonString) as List;
        return list
            .map((e) => WallpaperModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw CacheException(message: 'Failed to decode favorites: $e');
      }
    }
    return [];
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((element) => element.id == id);
  }

  Future<void> _persist(List<WallpaperModel> list) async {
    final String jsonString = json.encode(list.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_favoritesKey, jsonString);
  }
}
