import 'package:final_project/FirstComponent/home_main.dart';
import 'package:flutter/material.dart';

import '../FirstComponent/home_recommend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2, // 탭의 개수
        child: Scaffold(
          appBar: AppBar(
            title: const Text(''), // 빈 텍스트로 타이틀을 설정하여 없애기
            backgroundColor: Colors.black,
            toolbarHeight: 10.0, // AppBar의 높이 조정
            bottom: TabBar(
                indicatorColor:Colors.orange,
                tabs: [
                Tab(text: '피드'),
                Tab(text: '추천'),
              ],
              labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // 탭의 글꼴 크기 조정
            ),
          ),
          body: TabBarView(
            children: [
              HomeMain(), // 피드 화면
              HomeRecommend(), // 추천 화면
            ],
          ),
        ),
      ),
    );
  }
}

