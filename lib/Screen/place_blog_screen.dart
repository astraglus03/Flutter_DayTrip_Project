import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PlaceBlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('장소 블로그 화면'),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    child: Image.asset('asset/img/school1.jpg', fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 6.0,
                    left: 16.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '장소 이름이 들어갈 부분.\n\n 천안, 안서동 . 공부',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      height: kToolbarHeight + MediaQuery.of(context).padding.top,
                      decoration: BoxDecoration(

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white,),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.home_outlined, color: Colors.white,),
                                onPressed: () {
                                  // 메뉴 버튼 동작
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz, color: Colors.white,),
                                onPressed: () {
                                  // 메뉴 버튼 동작
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10,),

              // 사용자 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 사용자 1 버튼 wpqkf
                  ElevatedButton(
                    onPressed: () {
                      // 사용자 1 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경을 투명으로 설정
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('asset/img/friend2.jpg'),
                      radius: 30.0, // 버튼 크기 조절
                    ),
                  ),

                  // 사용자 2 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 사용자 2 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경을 투명으로 설정
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('asset/img/friend1.jpg'),
                      radius: 30.0, // 버튼 크기 조절
                    ),
                  ),
                  // 추가 사용자 버튼...
                  ElevatedButton(
                    onPressed: () {
                      // 사용자 3 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경을 투명으로 설정
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('asset/img/friend3.jpg'),
                      radius: 30.0, // 버튼 크기 조절
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 사용자 4 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경을 투명으로 설정
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('asset/img/friend1.jpg'),
                      radius: 30.0, // 버튼 크기 조절
                    ),
                  ),
                ],
              ),

              // 선택된 사용자가 쓴 글 표시
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 사용자 글',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    // 사용자가 쓴 글들을 여기에 표시
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
