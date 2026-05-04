import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/wallpaper_action_service.dart';
import 'wallpaper_action_state.dart';

class WallpaperActionCubit extends Cubit<WallpaperActionState> {
  final WallpaperActionService _wallpaperService;

  WallpaperActionCubit(this._wallpaperService) : super(WallpaperActionInitial());

  Future<void> setWallpaper({
    required String imageUrl,
    required WallpaperTargetType target,
  }) async {
    emit(WallpaperActionLoading());

    final success = await _wallpaperService.setWallpaper(
      imageUrl: imageUrl,
      target: target,
    );

    if (isClosed) return;

    if (success) {
      emit(const WallpaperActionSuccess('Wallpaper set successfully!'));
    } else {
      emit(const WallpaperActionFailure('Failed to set wallpaper. Please try again.'));
    }
  }
}
