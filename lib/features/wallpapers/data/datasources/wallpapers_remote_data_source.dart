import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/wallpaper_model.dart';

abstract class WallpapersRemoteDataSource {
  Future<List<WallpaperModel>> getWallpapers({
    required int page,
    required int perPage,
  });

  Future<List<WallpaperModel>> getWallpapersByCategory({
    required String category,
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
        '/curated',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final List photos = response.data['photos'] as List;
      return photos
          .map((e) => WallpaperModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<WallpaperModel>> getWallpapersByCategory({
    required String category,
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await client.get(
        '/search',
        queryParameters: {'query': category, 'page': page, 'per_page': perPage},
      );

      final List photos = response.data['photos'] as List;
      return photos
          .map(
            (e) => WallpaperModel.fromJson(
              e as Map<String, dynamic>,
              category: category,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WallpaperModel> getWallpaperById(String id) async {
    try {
      final response = await client.get('/photos/$id');
      return WallpaperModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  ServerException _handleDioException(DioException e) {
    String message = 'An unexpected error occurred';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please check your internet.';
        break;
      case DioExceptionType.badResponse:
        message = e.response?.data['error'] ??
            'Server error (${e.response?.statusCode})';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      default:
        message = e.message ?? 'Something went wrong';
    }

    return ServerException(message: message);
  }
}
