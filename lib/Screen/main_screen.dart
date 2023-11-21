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

  // 바텀 내비바 선택 인덱스
  int _selectedIndex = 0;

  // 페이지 목록
  final List<Widget> _pages = [
    // 바텀내비바 홈화면
    HomeScreen(),

    // 바텀내비바 지도
    MapScreen(),

    // 이 위젯은 사용하지는 않지만 임시로 인덱스를 채우기 위해서 만들어놓은 위젯임
    PlusWidget(),

    // 바텀내비바 상태
    BookMarkScreen(),

    // 바텀내비바 카메라
    MyPageScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        _showCustomBottomSheet(context);
      } else {
        _selectedIndex = index;
      }
    });
  }

  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // 바텀 시트 이외의 부분 클릭했을때 이벤트
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // 바텀 시트 위의 공간 height(빠른 체크인 위의 여백공간 조절)
                height: 30,
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[300],
                  ),
                  child: Icon(Icons.add_location_rounded, color: Colors.red,),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("빠른 체크인", style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),),
                    SizedBox(height: 3,),
                    Text("쉽게 남기는 방문 기록", style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),),
                  ],
                ),
                onTap: () {
                  // 현재는 이벤트 처리 말고 그냥 닫히게 해뒀음.
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10,),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[300],
                  ),
                  child: Icon(Icons.photo_outlined, color: Colors.lightBlueAccent,),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("데이로그", style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),),
                    SizedBox(height: 3,),
                    Text("사진과 함께 기록하는 공간 경험", style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),),
                  ],
                ),
                onTap: () {
                  // 현재는 이벤트 처리 말고 그냥 닫히게 해뒀음.
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 30,),
            ],
          ),
        );
      },
    );
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