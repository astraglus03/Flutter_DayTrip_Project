import 'package:final_project/FifthComponent/daylog.dart';
import 'package:final_project/FifthComponent/export_setting.dart';
import 'package:final_project/FifthComponent/introduce_logout.dart';
import 'package:final_project/FifthComponent/post_titlebar.dart';
import 'package:final_project/FifthComponent/profile.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: _MyPersistentHeader(),
          ),

          SliverFillRemaining(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    // 내 계정 프로필
                    ProfileTile(),

                    SizedBox(height: 10,),

                    // 자기 소개글 입력 및 로그아웃
                    IntroduceAndLogout(),

                    SizedBox(height: 20,),

                    PostTitleBar(),
                    // My Page
                    DayLog(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 스크롤되지않게 고정해놓는 상속 함수
class _MyPersistentHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Customize header color if needed
      child: ExportSettings(), // Your ExportSettings widget
    );
  }

  @override
  double get maxExtent => 50.0; // Set the maximum height of the header
  @override
  double get minExtent => 50.0; // Set the minimum height of the header
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
