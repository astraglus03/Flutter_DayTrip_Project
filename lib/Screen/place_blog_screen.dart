import 'package:flutter/material.dart';

class PlaceBlogScreen extends StatefulWidget {
  @override
  _PlaceBlogScreenState createState() => _PlaceBlogScreenState();
}

class _PlaceBlogScreenState extends State<PlaceBlogScreen> {
  int selectedUserIndex = -1; // 선택된 사용자를 추적하기 위한 변수
  List<String> userPosts = [
    '사용자 1의 글입니다.',
    '사용자 2의 글입니다.',
    '사용자 3의 글입니다.',
    '사용자 4의 글입니다.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // 사용자 1 버튼
                  InkWell(
                    onTap: () {
                      // 사용자 1 선택 시 처리
                      setState(() {
                        selectedUserIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedUserIndex == 0 ? Colors.white : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('asset/img/friend2.jpg'),
                        radius: 20.0,
                      ),
                    ),
                  ),

                  // 사용자 2 버튼
                  InkWell(
                    onTap: () {
                      // 사용자 2 선택 시 처리
                      setState(() {
                        selectedUserIndex = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedUserIndex == 1 ? Colors.white : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('asset/img/friend1.jpg'),
                        radius: 20.0,
                      ),
                    ),
                  ),

                  // 추가 사용자 버튼...
                  InkWell(
                    onTap: () {
                      // 사용자 3 선택 시 처리
                      setState(() {
                        selectedUserIndex = 2;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedUserIndex == 2 ? Colors.white : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('asset/img/friend3.jpg'),
                        radius: 20.0,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      // 사용자 4 선택 시 처리
                      setState(() {
                        selectedUserIndex = 3;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedUserIndex == 3 ? Colors.white : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('asset/img/friend1.jpg'),
                        radius: 20.0,
                      ),
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
                    selectedUserIndex != -1
                        ? Text(
                      userPosts[selectedUserIndex],
                      style: TextStyle(fontSize: 18.0),
                    )
                        : SizedBox.shrink(),
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
