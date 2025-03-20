
import 'package:flutter/material.dart';
import 'package:healthify_app/ui/chatbot.dart';
import 'package:healthify_app/ui/home.dart';
import 'package:healthify_app/ui/ingredients_scanner.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    HomeScreen(),
    IngredientScannerScreen(),
    Chatbot()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Summerizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Chatbot',
          ),
        ],
      ),
    );
  }
}


