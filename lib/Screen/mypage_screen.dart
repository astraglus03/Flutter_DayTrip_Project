import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/FifthComponent/daylog.dart';
import 'package:final_project/FifthComponent/export_setting.dart';
import 'package:final_project/FifthComponent/introduce_logout.dart';
import 'package:final_project/FifthComponent/post_titlebar.dart';
import 'package:final_project/model_db/onelinemodel.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[

          SliverFillRemaining(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),

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