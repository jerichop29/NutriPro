import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';  // For the LineIcons used in the navbar.
import 'package:nutripro/screen/guide/guide.dart';
import 'package:nutripro/screen/storage/storage.dart';
import '../../screen/history/history.dart';
import '../../screen/home/home.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color of the nav bar
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), // Padding around the nav bar
      child: GNav(
        gap: 8, // Gap between icon and text
        color: Colors.grey[800], // Unselected icon color
        activeColor: Colors.white, // Default selected icon and text color (override below for each tab)
        iconSize: 24, // Icon size
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7), // Padding for nav items
        tabBorderRadius: 15, // Radius for the tab background
        haptic: true, // Enable haptic feedback
        selectedIndex: currentIndex, // Selected index based on the current screen
        onTabChange: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
              );
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => GuideScreen()),
                    (Route<dynamic> route) => false,
              );
              break;
            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
                    (Route<dynamic> route) => false,
              );
              break;
            case 3:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StorageScreen()),
                    (Route<dynamic> route) => false,
              );
              break;
          }
          onTap(index); // Pass the updated index to the parent widget
        },
        tabs: [
          // Home Tab: Dark Blue Icon, Light Blue Background when selected
          GButton(
            icon: LineIcons.home,
            text: 'Home',
            iconColor: Colors.black, // Unselected icon color
            iconActiveColor: Colors.blue[900], // Dark blue when selected
            textColor: Colors.blue[900], // Dark blue text when selected
            backgroundColor: Colors.blue[100], // Light blue background when selected
          ),
          // Guide Tab: Dark Red Icon, Light Red Background when selected
          GButton(
            icon: LineIcons.questionCircle,
            text: 'Guide',
            iconColor: Colors.black, // Unselected icon color
            iconActiveColor: Colors.purple[900], // Dark red when selected
            textColor: Colors.purple[900], // Dark red text when selected
            backgroundColor: Colors.purple[100], // Light red background when selected
          ),
          // History Tab: Dark Yellow Icon, Light Yellow Background when selected
          GButton(
            icon: LineIcons.history,
            text: 'History',
            iconColor: Colors.black, // Unselected icon color
            iconActiveColor: Colors.amber[900], // Dark yellow when selected
            textColor: Colors.amber[900], // Dark yellow text when selected
            backgroundColor: Colors.amber[100], // Light yellow background when selected
          ),
          // Storage Tab: Dark Green Icon, Light Green Background when selected
          GButton(
            icon: LineIcons.archive,
            text: 'Storage',
            iconColor: Colors.black, // Unselected icon color
            iconActiveColor: Colors.green[900], // Dark green when selected
            textColor: Colors.green[900], // Dark green text when selected
            backgroundColor: Colors.green[100], // Light green background when selected
          ),
        ],
      ),
    );
  }
}
