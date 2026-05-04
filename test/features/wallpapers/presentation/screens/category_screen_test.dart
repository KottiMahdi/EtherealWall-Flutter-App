import 'package:ethereal_wall/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_state.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/screens/category_screen.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/widgets/editorial_collections_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/favorites_cubit.dart';
import 'package:ethereal_wall/core/theme/theme_cubit.dart';
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

class MockThemeCubit extends MockCubit<ThemeMode>
    implements ThemeCubit {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockWallpaperCubit mockCubit;
  late MockFavoritesCubit mockFavoritesCubit;
  late MockThemeCubit mockThemeCubit;
  late MockGoRouter mockRouter;

  setUp(() {
    mockCubit = MockWallpaperCubit();
    mockFavoritesCubit = MockFavoritesCubit();
    mockThemeCubit = MockThemeCubit();
    mockRouter = MockGoRouter();

    // Setup Service Locator (sl)
    if (sl.isRegistered<WallpaperCubit>()) {
      sl.unregister<WallpaperCubit>();
    }
    sl.registerFactory<WallpaperCubit>(() => mockCubit);

    // Stub mandatory calls
    when(() => mockCubit.fetchWallpapersByCategory(any()))
        .thenAnswer((_) async {});
    when(() => mockFavoritesCubit.loadFavorites()).thenAnswer((_) async {});
    when(() => mockFavoritesCubit.state).thenReturn(FavoritesInitial());
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
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

  Widget createWidgetUnderTest({String category = 'Explore'}) {
    return MaterialApp(
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FavoritesCubit>.value(value: mockFavoritesCubit),
            BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
          ],
          child: CategoryScreen(category: category),
        ),
      ),
    );
  }

  void setupView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 5000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  testWidgets('should display Explore header when category is Explore',
      (tester) async {
    setupView(tester);
    when(() => mockCubit.state).thenReturn(WallpaperInitial());

    await tester.pumpWidget(createWidgetUnderTest(category: 'Explore'));
    await tester.pump();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.byType(EditorialCollectionsGrid), findsOneWidget);
  });

  testWidgets('should display category name when a specific category is selected',
      (tester) async {
    setupView(tester);
    when(() => mockCubit.state).thenReturn(WallpaperInitial());

    await tester.pumpWidget(createWidgetUnderTest(category: 'Abstract'));
    await tester.pump();

    expect(find.text('Abstract'), findsOneWidget);
  });

  testWidgets('should show back button in AppBar when inside a category',
      (tester) async {
    setupView(tester);
    when(() => mockCubit.state).thenReturn(WallpaperInitial());

    await tester.pumpWidget(createWidgetUnderTest(category: 'Nature'));
    await tester.pump();

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });

  testWidgets('should reset to Explore view when back button is tapped',
      (tester) async {
    setupView(tester);
    when(() => mockCubit.state).thenReturn(WallpaperInitial());

    await tester.pumpWidget(createWidgetUnderTest(category: 'Nature'));
    await tester.pump();

    final backButton = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backButton);
    await tester.pump();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.byType(EditorialCollectionsGrid), findsOneWidget);
  });

  testWidgets('should display wallpapers when state is WallpaperLoaded',
      (tester) async {
    setupView(tester);
    await mockNetworkImages(() async {
      when(() => mockCubit.state)
          .thenReturn(const WallpaperLoaded(wallpapers: tWallpapers));

      await tester.pumpWidget(createWidgetUnderTest(category: 'Nature'));
      await tester.pumpAndSettle();

      expect(find.text('Nature Art'), findsAtLeast(1));
    });
  });
}
