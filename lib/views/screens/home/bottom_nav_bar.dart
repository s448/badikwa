import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:prufcoach/core/utils/asset_pathes.dart';
import 'package:prufcoach/views/screens/home/home_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 1,
  );

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      selectedTabPressConfig: SelectedTabPressConfig(
        popAction: PopActionType.none, // Do nothing on same-tab press
        scrollToTop: true, // Disable scroll-to-top
      ),
      tabs: [
        PersistentTabConfig(
          screen: const Center(child: Text('Settings Page')),
          item: ItemConfig(
            icon: Image.asset(
              AssetPaths.settingsIconSelected,
              width: 36,
              height: 36,
            ),
            inactiveIcon: Image.asset(
              AssetPaths.settingsIcon,
              width: 36,
              height: 36,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: Image.asset(
              AssetPaths.homeIconSelected,
              width: 36,
              height: 36,
            ),
            inactiveIcon: Image.asset(
              AssetPaths.homeIcon,
              width: 36,
              height: 36,
            ),
          ),
        ),
        PersistentTabConfig(
          screen: const Center(child: Text('Profile Page')),
          item: ItemConfig(
            icon: Image.asset(
              AssetPaths.profileIconSelected,
              width: 36,
              height: 36,
            ),
            inactiveIcon: Image.asset(
              AssetPaths.profileIcon,
              width: 36,
              height: 36,
            ),
          ),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => Style1BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
