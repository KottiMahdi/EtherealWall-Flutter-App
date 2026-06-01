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

class MockGetWallpapersByCategory extends Mock
    implements GetWallpapersByCategory {}

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

  const tMoreWallpapers = [
    Wallpaper(
      id: '2',
      title: 'More Wallpaper',
      imageUrl: 'https://test.com/image-2.jpg',
      thumbnailUrl: 'https://test.com/thumb-2.jpg',
      category: 'Nature',
      photographer: 'Second Photographer',
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
        when(
          () => mockGetWallpapers(any()),
        ).thenAnswer((_) async => const Right(tWallpapers));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapers(),
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers, hasMore: false),
      ],
      verify: (_) {
        verify(() => mockGetWallpapers(any())).called(1);
      },
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperError] when getting data fails',
      build: () {
        when(() => mockGetWallpapers(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapers(),
      expect: () => [
        WallpaperLoading(),
        const WallpaperError(message: 'Server Error'),
      ],
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should append wallpapers when loading more curated wallpapers',
      build: () {
        when(() => mockGetWallpapers(any())).thenAnswer((invocation) async {
          final params =
              invocation.positionalArguments.first as GetWallpapersParams;
          return params.page == 1
              ? const Right(tWallpapers)
              : const Right(tMoreWallpapers);
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchWallpapers(page: 1, perPage: 1);
        await cubit.fetchWallpapers(perPage: 1, loadMore: true);
      },
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers),
        const WallpaperLoaded(wallpapers: tWallpapers, isLoadingMore: true),
        const WallpaperLoaded(wallpapers: [...tWallpapers, ...tMoreWallpapers]),
      ],
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should keep current wallpapers when loading more curated wallpapers fails',
      build: () {
        when(() => mockGetWallpapers(any())).thenAnswer((invocation) async {
          final params =
              invocation.positionalArguments.first as GetWallpapersParams;
          return params.page == 1
              ? const Right(tWallpapers)
              : const Left(ServerFailure(message: 'Server Error'));
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchWallpapers(page: 1, perPage: 1);
        await cubit.fetchWallpapers(perPage: 1, loadMore: true);
      },
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers),
        const WallpaperLoaded(wallpapers: tWallpapers, isLoadingMore: true),
        const WallpaperLoaded(
          wallpapers: tWallpapers,
          loadMoreError: 'Server Error',
        ),
      ],
    );
  });

  group('fetchWallpapersByCategory', () {
    const tCategory = 'Nature';

    setUpAll(() {
      registerFallbackValue(
        GetWallpapersByCategoryParams(
          category: tCategory,
          page: 1,
          perPage: 30,
        ),
      );
    });

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperLoaded] when data is gotten successfully',
      build: () {
        when(
          () => mockGetWallpapersByCategory(any()),
        ).thenAnswer((_) async => const Right(tWallpapers));
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapersByCategory(tCategory),
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers, hasMore: false),
      ],
      verify: (_) {
        verify(() => mockGetWallpapersByCategory(any())).called(1);
      },
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should emit [WallpaperLoading, WallpaperError] when getting data fails',
      build: () {
        when(() => mockGetWallpapersByCategory(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server Error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.fetchWallpapersByCategory(tCategory),
      expect: () => [
        WallpaperLoading(),
        const WallpaperError(message: 'Server Error'),
      ],
    );

    blocTest<WallpaperCubit, WallpaperState>(
      'should append wallpapers when loading more category wallpapers',
      build: () {
        when(() => mockGetWallpapersByCategory(any())).thenAnswer((
          invocation,
        ) async {
          final params =
              invocation.positionalArguments.first
                  as GetWallpapersByCategoryParams;
          return params.page == 1
              ? const Right(tWallpapers)
              : const Right(tMoreWallpapers);
        });
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchWallpapersByCategory(tCategory, page: 1, perPage: 1);
        await cubit.fetchWallpapersByCategory(
          tCategory,
          perPage: 1,
          loadMore: true,
        );
      },
      expect: () => [
        WallpaperLoading(),
        const WallpaperLoaded(wallpapers: tWallpapers),
        const WallpaperLoaded(wallpapers: tWallpapers, isLoadingMore: true),
        const WallpaperLoaded(wallpapers: [...tWallpapers, ...tMoreWallpapers]),
      ],
    );
  });
}
