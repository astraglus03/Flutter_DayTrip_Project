import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("hello"),
            // 환경설정 위젯

            // 이미지, 로그인 했을때 나타내줄 이름( ex) kkd0250@gmail.com) 오른쪽 부분 로그아웃

            // 데이로그 이미지 타임라인 + 내가 쓴 한줄 메모 저장되는 곳.

          ],
        ),
      ),
    );
  }
}
