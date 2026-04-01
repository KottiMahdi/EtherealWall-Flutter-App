import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_client.dart';
import 'features/wallpapers/data/datasources/wallpapers_local_data_source.dart';
import 'features/wallpapers/data/datasources/wallpapers_remote_data_source.dart';
import 'features/wallpapers/data/repositories/wallpapers_repository_impl.dart';
import 'features/wallpapers/domain/repositories/wallpapers_repository.dart';
import 'features/wallpapers/domain/usecases/get_favorites.dart';
import 'features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'features/wallpapers/domain/usecases/get_wallpapers_by_category.dart';
import 'features/wallpapers/domain/usecases/toggle_favorite.dart';
import 'features/wallpapers/presentation/bloc/wallpapers_bloc.dart';
import 'features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'features/wallpapers/presentation/cubit/favorites_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── External ─────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ─── Core ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<Dio>(() => NetworkClient.createDio());

  // ─── Features ─────────────────────────────────────────────────────────────
  _initWallpapers();
}

void _initWallpapers() {
  // BLoC
  sl.registerFactory(() => WallpapersBloc(getWallpapers: sl()));
  // Cubit
  sl.registerFactory(
    () => WallpaperCubit(getWallpapers: sl(), getWallpapersByCategory: sl()),
  );
  sl.registerFactory(
    () => FavoritesCubit(
      getFavorites: sl(),
      toggleFavorite: sl(),
      repository: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetWallpapers(sl()));
  sl.registerLazySingleton(() => GetWallpapersByCategory(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  // Repository
  sl.registerLazySingleton<WallpapersRepository>(
    () =>
        WallpapersRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<WallpapersRemoteDataSource>(
    () => WallpapersRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WallpapersLocalDataSource>(
    () => WallpapersLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
