import 'package:ethereal_wall/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_state.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/favorites_cubit.dart';
import 'package:ethereal_wall/core/di/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';

class MockWallpaperCubit extends MockCubit<WallpaperState>
    implements WallpaperCubit {}

class MockFavoritesCubit extends MockCubit<FavoritesState>
    implements FavoritesCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockWallpaperCubit mockCubit;
  late MockFavoritesCubit mockFavoritesCubit;
  late MockGoRouter mockRouter;

  setUp(() {
    mockCubit = MockWallpaperCubit();
    mockFavoritesCubit = MockFavoritesCubit();
    mockRouter = MockGoRouter();

    // Setup Service Locator (sl)
    if (sl.isRegistered<WallpaperCubit>()) {
      sl.unregister<WallpaperCubit>();
    }
    sl.registerFactory<WallpaperCubit>(() => mockCubit);

    // Stub mandatory calls
    when(() => mockCubit.fetchWallpapers()).thenAnswer((_) async {});
    when(() => mockFavoritesCubit.loadFavorites()).thenAnswer((_) async {});
    when(() => mockFavoritesCubit.state).thenReturn(FavoritesInitial());
  });

  tearDown(() {
    mockCubit.close();
  });

  const tWallpapers = [
    Wallpaper(
      id: '1',
      title: 'Nature Art',
      imageUrl: 'https://test.com/image.jpg',
      thumbnailUrl: 'https://test.com/thumb.jpg',
      category: 'Nature',
      photographer: 'Jane Doe',
      width: 1920,
      height: 1080,
    ),
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: BlocProvider<FavoritesCubit>.value(
          value: mockFavoritesCubit,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  void setupView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 5000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  testWidgets('should display Daily Muse header always', (tester) async {
    setupView(tester);
    when(() => mockCubit.state).thenReturn(WallpaperInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Daily Muse'), findsOneWidget);
  });

  testWidgets(
    'should display CircularProgressIndicator when state is WallpaperLoading',
    (tester) async {
      setupView(tester);
      when(() => mockCubit.state).thenReturn(WallpaperLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('should display error message when state is WallpaperError', (
    tester,
  ) async {
    setupView(tester);
    const errorMessage = 'Network Error';
    when(
      () => mockCubit.state,
    ).thenReturn(const WallpaperError(message: errorMessage));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should display wallpapers when state is WallpaperLoaded', (
    tester,
  ) async {
    setupView(tester);
    await mockNetworkImages(() async {
      when(
        () => mockCubit.state,
      ).thenReturn(const WallpaperLoaded(wallpapers: tWallpapers));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Nature Art'), findsAtLeast(1));
    });
  });

  testWidgets(
    'should navigate to preview screen when a wallpaper is tapped',
    (tester) async {
      setupView(tester);
      await mockNetworkImages(() async {
        when(
          () => mockCubit.state,
        ).thenReturn(const WallpaperLoaded(wallpapers: tWallpapers));
        
        when(() => mockRouter.push(any(), extra: any(named: 'extra')))
            .thenAnswer((_) async => null);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final wallpaperCard = find.text('Nature Art').first;
        await tester.tap(wallpaperCard);
        await tester.pump();

        verify(() => mockRouter.push('/preview', extra: tWallpapers[0])).called(1);
      });
    },
  );
}
