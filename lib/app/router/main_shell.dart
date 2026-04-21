import 'package:flutter/material.dart';
import '../../features/wallpapers/presentation/widgets/ethereal_bottom_bar.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final String stateUri;

  const MainShell({
    super.key,
    required this.child,
    required this.stateUri,
  });

  NavItem _getNavItem() {
    if (stateUri == '/') return NavItem.home;
    if (stateUri.startsWith('/category/Trending')) return NavItem.trending;
    if (stateUri.startsWith('/category')) return NavItem.browse;
    if (stateUri == '/favorites') return NavItem.favorites;
    return NavItem.home;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          EtherealBottomBar(activeItem: _getNavItem()),
        ],
      ),
    );
  }
}
