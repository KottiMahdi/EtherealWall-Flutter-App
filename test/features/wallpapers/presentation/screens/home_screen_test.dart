import 'package:ethereal_wall/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_state.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:bloc_test/bloc_test.dart';

class MockWallpaperCubit extends MockCubit<WallpaperState>
    implements WallpaperCubit {}

void main() {
  late MockWallpaperCubit mockCubit;

  setUp(() {
    mockCubit = MockWallpaperCubit();
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
      home: BlocProvider<WallpaperCubit>.value(
        value: mockCubit,
        child: const HomeScreen(),
      ),
    );
  }

  void setupView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 5000); // Very tall viewport
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
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Nature Art'), findsOneWidget);
    });
  });

  testWidgets(
    'should call fetchWallpapersByCategory when a category chip is tapped',
    (tester) async {
      setupView(tester);
      await mockNetworkImages(() async {
        when(
          () => mockCubit.state,
        ).thenReturn(const WallpaperLoaded(wallpapers: tWallpapers));
        when(
          () => mockCubit.fetchWallpapersByCategory(any()),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final natureChip = find.text('Nature');
        expect(natureChip, findsOneWidget);

        await tester.tap(natureChip);
        await tester.pump();

        verify(() => mockCubit.fetchWallpapersByCategory('Nature')).called(1);
      });
    },
  );
}
