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

  factory WallpaperModel.fromJson(
    Map<String, dynamic> json, {
    String? category,
  }) {
    // Safe mapping for both Remote API and Hive storage
    final src = json['src'] != null ? Map<String, dynamic>.from(json['src'] as Map) : {};

    return WallpaperModel(
      id: json['id']?.toString() ?? '',
      title: json['alt'] as String? ?? 'Ethereal Art',
      imageUrl: src['portrait'] as String? ?? src['large2x'] as String? ?? '',
      thumbnailUrl: src['medium'] as String? ?? src['small'] as String? ?? '',
      category: category ?? 'Collection',
      photographer: json['photographer'] as String? ?? 'Pexels Artist',
      width: json['width'] as int? ?? 1080,
      height: json['height'] as int? ?? 1920,
    );
  }

  factory WallpaperModel.fromEntity(Wallpaper wallpaper) {
    return WallpaperModel(
      id: wallpaper.id,
      title: wallpaper.title,
      imageUrl: wallpaper.imageUrl,
      thumbnailUrl: wallpaper.thumbnailUrl,
      category: wallpaper.category,
      photographer: wallpaper.photographer,
      width: wallpaper.width,
      height: wallpaper.height,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alt': title,
      'src': {'portrait': imageUrl, 'medium': thumbnailUrl},
      'category': category,
      'photographer': photographer,
      'width': width,
      'height': height,
    };
  }
}
