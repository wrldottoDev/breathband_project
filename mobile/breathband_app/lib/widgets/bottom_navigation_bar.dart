import 'package:flutter/material.dart';
import 'package:breathband_app/widgets/app_bar.dart';

class BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icons.home,
          title: 'Home',
        activeIcon: Icons.homeActive,
        ),
        BottomNavigationBarItem(
          icon: Icons.mail,
          title: 'Messages',
          activeIcon: Icons.mailActive,
        ),
        BottomNavigationBarItem(
          icon: Icons.person,
          title: 'Profile',
          activeIcon: Icons.personActive,
          ),
      ],
    unselectedIconTheme: IconTheme.light,
    unselectedIconTheme: IconTheme.dark,
    unselectedLabelStyle: TextStyle(color: Colors.white),
    selectedLabelStyle: TextStyle(color: Colors.blue),
    iconSize: 30,
    labelPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}