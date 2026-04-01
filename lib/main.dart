import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/wallpapers/presentation/cubit/favorites_cubit.dart';
import 'features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const EtherealWallApp());
}

class EtherealWallApp extends StatelessWidget {
  const EtherealWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WallpaperCubit>()..fetchWallpapers()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..loadFavorites()),
      ],
      child: MaterialApp.router(
        title: 'EtherealWall',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
