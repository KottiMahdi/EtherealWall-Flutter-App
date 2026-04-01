import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/wallpapers/domain/entities/wallpaper.dart';
import '../../features/wallpapers/presentation/screens/category_screen.dart';
import '../../features/wallpapers/presentation/screens/favorites_screen.dart';
import '../../features/wallpapers/presentation/screens/home_screen.dart';
import '../../features/wallpapers/presentation/screens/preview_screen.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String category = '/category/:name';
  static const String preview = '/preview';
  static const String favorites = '/favorites';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/category/:name',
        name: 'category',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          return CategoryScreen(category: name);
        },
      ),
      GoRoute(
        path: preview,
        name: 'preview',
        builder: (context, state) {
          final wallpaper = state.extra as Wallpaper;
          return PreviewScreen(wallpaper: wallpaper);
        },
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
}
