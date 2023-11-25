import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PlaceBlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('place_blog_screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 슬라이더
            CarouselSlider(
              items: [
                // 여러 이미지 위젯 추가
                Image.asset('asset/img/school1.jpg'),
                Image.asset('asset/img/school2.jpg'),
                Image.asset('asset/img/school3.jpg'),
                // Add more image paths as needed
                // 추가 이미지...
              ],
              options: CarouselOptions(
                height: 200.0, // 이미지 슬라이더의 기본 높이
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 2.0, // 이 부분을 조절하여 이미지의 화면 차지 비율을 조절
              ),
            ),

            // 이미지 아래 설명
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '장소이름이 들어갈 부분.',
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            // 사용자 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 사용자1 선택 시 처리
                  },
                  child: Text('사용자1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 사용자2 선택 시 처리
                  },
                  child: Text('사용자2'),
                ),
                // 추가 사용자 버튼...
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

            // 추가적인 위젯들 또는 페이지 컨텐츠를 계속 추가할 수 있습니다.
            // ...

          ],
        ),
      ),
    );
  }
}
