import 'package:final_project/Screen/mypage_screen.dart';
import 'package:final_project/Screen/home_screen.dart';
import 'package:final_project/Screen/map_screen.dart';
import 'package:final_project/Screen/bookmark_screen.dart';
import 'package:final_project/Screen/plus_widget.dart';
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

  // 바텀내비바 지도
    MapScreen(),

    // 3번은 스크린이 아니라 위젯으로 포함되는게 맞을거같아서 임시로 컨테이너 넣어두었다.
    PlusWidget(),

    // 바텀내비바 상태
    BookMarkScreen(),

    // 바텀내비바 카메라
    MyPageScreen(),
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
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}