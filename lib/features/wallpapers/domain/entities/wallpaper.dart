import 'package:equatable/equatable.dart';

class Wallpaper extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String thumbnailUrl;
  final String category;
  final String photographer;
  final int width;
  final int height;

  const Wallpaper({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.photographer,
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [
        id,
        title,
        imageUrl,
        thumbnailUrl,
        category,
        photographer,
        width,
        height,
      ];
}
