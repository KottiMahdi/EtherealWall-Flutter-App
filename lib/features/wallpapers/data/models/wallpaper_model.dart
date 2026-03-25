import '../../domain/entities/wallpaper.dart';

class WallpaperModel extends Wallpaper {
  const WallpaperModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.thumbnailUrl,
    required super.category,
    required super.photographer,
    required super.width,
    required super.height,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
      photographer: json['photographer'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'category': category,
      'photographer': photographer,
      'width': width,
      'height': height,
    };
  }
}
