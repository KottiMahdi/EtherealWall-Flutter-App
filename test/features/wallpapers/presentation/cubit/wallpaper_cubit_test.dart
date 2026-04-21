import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ethereal_wall/core/errors/failures.dart';
import 'package:ethereal_wall/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:ethereal_wall/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:ethereal_wall/features/wallpapers/domain/usecases/get_wallpapers_by_category.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_cubit.dart';
import 'package:ethereal_wall/features/wallpapers/presentation/cubit/wallpaper_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWallpapers extends Mock implements GetWallpapers {}

class MockGetWallpapersByCategory extends Mock implements GetWallpapersByCategory {}

void main() {
  late WallpaperCubit cubit;
  late MockGetWallpapers mockGetWallpapers;
  late MockGetWallpapersByCategory mockGetWallpapersByCategory;

  setUp(() {
    mockGetWallpapers = MockGetWallpapers();
    mockGetWallpapersByCategory = MockGetWallpapersByCategory();
    cubit = WallpaperCubit(
      getWallpapers: mockGetWallpapers,
      getWallpapersByCategory: mockGetWallpapersByCategory,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tWallpapers = [
    Wallpaper(
      id: '1',
      title: 'Test Wallpaper',
      imageUrl: 'https://test.com/image.jpg',
      thumbnailUrl: 'https://test.com/thumb.jpg',
      category: 'Nature',
      photographer: 'Test Photographer',
      width: 1920,
      height: 1080,
    ),
  ];

  test('initial state should be WallpaperInitial', () {
    expect(cubit.state, equals(WallpaperInitial()));
  });

  group('fetchWallpapers', () {
    setUpAll(() {
      registerFallbackValue(GetWallpapersParams(page: 1, perPage: 30));
    });

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetWallpapers(any()))
            .thenAnswer((_) async => const Right(tWallpapers));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapers(),
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers),
      ],
      verify: (_) {
        verify(() => mockGetWallpapers(any())).called(1);
      },
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperError] when getting data fails',
      build: () {
        when(() => mockGetWallpapers(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapers(),
      expect: () => [
        WallpaperLoading(),
        const WallpaperError(message: 'Server Error'),
      ],
    );
  });

  group('fetchWallpapersByCategory', () {
    const tCategory = 'Nature';

    setUpAll(() {
      registerFallbackValue(
        GetWallpapersByCategoryParams(category: tCategory, page: 1, perPage: 30),
      );
    });

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetWallpapersByCategory(any()))
            .thenAnswer((_) async => const Right(tWallpapers));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapersByCategory(tCategory),
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers),
      ],
      verify: (_) {
        verify(() => mockGetWallpapersByCategory(any())).called(1);
      },
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperError] when getting data fails',
      build: () {
        when(() => mockGetWallpapersByCategory(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapersByCategory(tCategory),
      expect: () => [
        WallpaperLoading(),
        const WallpaperError(message: 'Server Error'),
      ],
    );
  });
}
