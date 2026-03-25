import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_client.dart';
import 'features/wallpapers/data/datasources/wallpapers_remote_data_source.dart';
import 'features/wallpapers/data/repositories/wallpapers_repository_impl.dart';
import 'features/wallpapers/domain/repositories/wallpapers_repository.dart';
import 'features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'features/wallpapers/presentation/bloc/wallpapers_bloc.dart';

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
  // Use cases
  sl.registerLazySingleton(() => GetWallpapers(sl()));
  // Repository
  sl.registerLazySingleton<WallpapersRepository>(
      () => WallpapersRepositoryImpl(remoteDataSource: sl()));
  // Data sources
  sl.registerLazySingleton<WallpapersRemoteDataSource>(
      () => WallpapersRemoteDataSourceImpl(client: sl()));
}
