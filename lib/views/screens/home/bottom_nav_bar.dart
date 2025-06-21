import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:prufcoach/core/utils/asset_pathes.dart';
import 'package:flutter/material.dart';
import 'package:prufcoach/views/screens/home/home_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  // int currentIndex = 1;
  final PersistentTabController controller = PersistentTabController(
    initialIndex: 1, // screen number 1 (second tab)
  );

  @override
  Widget build(BuildContext context) {
    // final List<Widget> pages = const [
    //   Center(child: Text('Settings Page')),
    //   Center(child: HomeScreen()),
    //   Center(child: Text('Profile Page')),
    // ];

    // final List<String> activeIcons = [
    //   AssetPaths.settingsIconSelected,
    //   AssetPaths.homeIconSelected,
    //   AssetPaths.profileIconSelected,
    // ];

    // final List<String> inactiveIcons = [
    //   AssetPaths.settingsIcon,
    //   AssetPaths.homeIconSelected,
    //   AssetPaths.profileIcon,
    // ];

    return Scaffold(
      body: PersistentTabView(
        controller: controller,
        tabs: [
          PersistentTabConfig(
            screen: Center(child: Text('Settings Page')),
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
            screen: Center(child: HomeScreen()),
            item: ItemConfig(
              icon: Image.asset(
                AssetPaths.homeIconSelected,
                width: 36,
                height: 36,
              ),
              inactiveIcon: Image.asset(
                AssetPaths.homeIconSelected,
                width: 36,
                height: 36,
              ),
            ),
          ),
          PersistentTabConfig(
            screen: Center(child: Text('Profile Page')),
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
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentIndex,
      //   backgroundColor: Colors.white,
      //   onTap: (index) => setState(() => currentIndex = index),
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: List.generate(3, (index) {
      //     bool isSelected = currentIndex == index;
      //     return BottomNavigationBarItem(
      //       label: '',
      //       icon: AnimatedContainer(
      //         duration: const Duration(milliseconds: 20),
      //         padding: const EdgeInsets.all(6),
      //         child: Image.asset(
      //           isSelected ? activeIcons[index] : inactiveIcons[index],
      //           width: isSelected ? 36 : 28,
      //           height: isSelected ? 36 : 28,
      //         ),
      //       ),
      //     );
      //   }),
      // ),
    );
  }
}
