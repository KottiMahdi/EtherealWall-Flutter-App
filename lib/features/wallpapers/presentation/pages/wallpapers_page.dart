import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/wallpapers_bloc.dart';
import '../widgets/wallpaper_card.dart';

class WallpapersPage extends StatelessWidget {
  const WallpapersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WallpapersBloc>()
        ..add(const FetchWallpapersEvent()),
      child: const _WallpapersView(),
    );
  }
}

class _WallpapersView extends StatelessWidget {
  const _WallpapersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
        centerTitle: true,
      ),
      body: BlocBuilder<WallpapersBloc, WallpapersState>(
        builder: (context, state) {
          return switch (state) {
            WallpapersInitial() => const SizedBox.shrink(),
            WallpapersLoading() =>
              const Center(child: CircularProgressIndicator()),
            WallpapersLoaded(:final wallpapers) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: wallpapers.length,
                itemBuilder: (context, index) =>
                    WallpaperCard(wallpaper: wallpapers[index]),
              ),
            WallpapersError(:final message) => Center(
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
