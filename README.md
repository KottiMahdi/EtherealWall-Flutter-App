# EtherealWall

EtherealWall is a polished Flutter wallpaper app designed to help users discover, favorite, preview, and set beautiful wallpapers directly from their mobile device. The app offers a modern browsing experience with curated categories, dark/light themes, and seamless gallery integration.

## Features

- Browse curated wallpaper categories
- Preview wallpapers before applying
- Favorite wallpapers for fast access
- Set wallpapers directly from the app
- Save wallpapers to the device gallery
- Dark and light theme support
- Built with clean architecture and modern Flutter best practices

## Getting Started

### Prerequisites

- Flutter SDK 3.9 or later
- Android Studio / Xcode for platform builds
- A connected Android or iOS device, or an emulator

### Install

```bash
flutter pub get
```

### Run

```bash
flutter run
```

## Project Structure

- `lib/` – main application code
- `lib/app/` – app-level setup and configuration
- `lib/core/` – shared utilities, theme, dependency injection
- `lib/features/` – feature modules for wallpapers, favorites, preview, and categories
- `pubspec.yaml` – dependencies and project metadata

## Architecture

EtherealWall uses:

- Flutter with `flutter_bloc` for state management
- Clean architecture principles
- Dependency injection for modular components
- Hive and shared preferences for local storage

## Dependencies

Key dependencies include:

- `flutter_bloc`
- `go_router`
- `cached_network_image`
- `hive`
- `dio`
- `permission_handler`
- `async_wallpaper`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes and open a pull request

## License

This project is currently private and not published. Update the license information as needed.
