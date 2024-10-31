import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/coach_screens/home/home.dart';
import 'package:playhub/features/coach_screens/profile/coach_profile.dart';

class CoachBottomNavBar extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => CoachBottomNavBar(),
      );
  const CoachBottomNavBar({super.key});

  @override
  State<CoachBottomNavBar> createState() => _CoachBottomNavBarState();
}

class _CoachBottomNavBarState extends State<CoachBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CoachProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: AppPalettes.foreground,
        color: AppPalettes.primary,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.sports_esports, color: AppPalettes.accent),
            label: 'Home',
            labelStyle: TextStyle(color: AppPalettes.accent),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.account_circle, color: AppPalettes.accent),
            label: 'Profile',
            labelStyle: TextStyle(color: AppPalettes.accent),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
