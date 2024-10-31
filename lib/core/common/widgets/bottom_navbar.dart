import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

import 'package:playhub/features/customer_screens/arena/presentation/arena.dart';
import 'package:playhub/features/customer_screens/coach/presentation/coach.dart';
import 'package:playhub/features/common/profile/profile.dart';
import 'package:playhub/features/customer_screens/shop/shop.dart';

class BottomNavbar extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BottomNavbar(),
      );
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Arena(),
    Coach(),
    Shop(),
    Profile(),
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
            label: 'Arena',
            labelStyle: TextStyle(color: AppPalettes.accent),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.school, color: AppPalettes.accent),
            label: 'Coach',
            labelStyle: TextStyle(color: AppPalettes.accent),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart, color: AppPalettes.accent),
            label: 'Shop',
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
