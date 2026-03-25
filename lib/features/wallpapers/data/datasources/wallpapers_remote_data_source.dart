import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/wallpaper_model.dart';

abstract class WallpapersRemoteDataSource {
  Future<List<WallpaperModel>> getWallpapers({
    required int page,
    required int perPage,
  });

  Future<WallpaperModel> getWallpaperById(String id);
}

class WallpapersRemoteDataSourceImpl implements WallpapersRemoteDataSource {
  final Dio client;

  WallpapersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<WallpaperModel>> getWallpapers({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await client.get(
        '/wallpapers',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final List data = response.data['data'] as List;
      return data
          .map((e) => WallpaperModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unexpected server error');
    }
  }

  @override
  Future<WallpaperModel> getWallpaperById(String id) async {
    try {
      final response = await client.get('/wallpapers/$id');
      return WallpaperModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unexpected server error');
    }
  }
}
