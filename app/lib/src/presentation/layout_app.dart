import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_e/src/presentation/account.dart';
import 'package:daily_e/src/presentation/home_page.dart';
import 'package:daily_e/src/presentation/setting_page.dart';
import 'package:flutter/material.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int _selectedIndex = 0; // Track the current selected index

  // Define a list of widgets for each page
  final List<Widget> _pages = [
    const HomePage(),
    const AccountPage(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page here
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 350),
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        items: const [
          Icon(Icons.home),
          Icon(Icons.account_circle),
          Icon(Icons.settings),
        ],
      ),
    );
  }
}
