import 'package:final_project/Screen/camera_screen.dart';
import 'package:final_project/Screen/control_screen.dart';
import 'package:final_project/Screen/home_screen.dart';
import 'package:final_project/Screen/map_screen.dart';
import 'package:final_project/Screen/status_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 페이지 목록
  final List<Widget> _pages = [
    // 바텀내비바 홈화면
    HomeScreen(),

    // 바텀내비바 제어
    ControlScreen(),

    // 바텀내비바 상태
    StatusScreen(),

    // 바텀내비바 지도
    MapScreen(),

    // 바텀내비바 카메라
    CameraScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_iphone),
            label: '제어',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: '상태',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_outward_outlined),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: '카메라',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}