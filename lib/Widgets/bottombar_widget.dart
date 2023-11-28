import 'package:deadstock/Screens/add_new_servics_screen.dart';
import 'package:deadstock/Screens/category.dart';
import 'package:deadstock/Screens/home_screen.dart';
import 'package:deadstock/Screens/notification_screen.dart';
import 'package:deadstock/Screens/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const AddNewService(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xb2bc322d),
          currentIndex: currentIndex,
          selectedLabelStyle: GoogleFonts.dmSans(fontSize: 13),
          unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 11),
          onTap: onTap,
          elevation: 1,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              activeIcon: Image.asset(
                "assets/icons/home.png",
                width: 23,
                color: Color(0xb2bc322d),
              ),
              icon: Image.asset(
                "assets/icons/home.png",
                width: 23,
                color: const Color(0xffb6b6b6),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Category',
              activeIcon: Image.asset(
                "assets/icons/categories.png",
                width: 23,
                color: Color(0xb2bc322d),
              ),
              icon: Image.asset(
                "assets/icons/categories.png",
                width: 23,
                color: const Color(0xffb6b6b6),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Add Product',
              activeIcon: Image.asset(
                "assets/icons/queue.png",
                width: 23,
                color: Color(0xb2bc322d),
              ),
              icon: Image.asset(
                "assets/icons/queue.png",
                width: 23,
                color: const Color(0xffb6b6b6),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Notification',
              activeIcon: Image.asset(
                "assets/icons/bell-ring.png",
                width: 23,
                color: Color(0xb2bc322d),
              ),
              icon: Image.asset(
                "assets/icons/bell-ring.png",
                width: 23,
                color: const Color(0xffb6b6b6),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              activeIcon: Image.asset(
                "assets/icons/user.png",
                width: 23,
                color: Color(0xb2bc322d),
              ),
              icon: Image.asset(
                "assets/icons/user.png",
                width: 23,
                color: const Color(0xffb6b6b6),
              ),
            ),
          ]),
    );
  }
}
