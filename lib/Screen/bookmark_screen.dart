import 'package:final_project/FourthComponent/title_bar.dart';
import 'package:flutter/material.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 공간 + 바
            TitleBar(),

            SizedBox(height: 10,),

            // 내가 저장한 게시물 게시물 보기.


            // 게시물 보기

          ],
        ),
      ),
    );
  }
}
