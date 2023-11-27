import 'package:final_project/FourthComponent/my_saved_list.dart';
import 'package:final_project/FourthComponent/save_class.dart';
import 'package:final_project/FourthComponent/post_list.dart';
import 'package:final_project/FourthComponent/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMarkScreen extends StatelessWidget {

  BookMarkScreen({Key? key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 공간 + 바
              TitleBar(),

              SizedBox(height: 20,),

              // 내가 저장한 게시물 게시물 보기.
              MySavedList(),


              SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                height: 10,
                child: Container(
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // 게시물 보기
              PostList(),

              SizedBox(height: 80,),

            ],
          ),
        ),
      ),
    );
  }
}
