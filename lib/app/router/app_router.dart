import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/wallpapers/presentation/pages/wallpapers_page.dart';

abstract class AppRouter {
  static const String wallpapers = '/';

  static final GoRouter router = GoRouter(
    initialLocation: wallpapers,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: wallpapers,
        name: 'wallpapers',
        builder: (context, state) => const WallpapersPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}
