import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/FifthComponent/daylog.dart';
import 'package:final_project/FifthComponent/export_setting.dart';
import 'package:final_project/FifthComponent/introduce_logout.dart';
import 'package:final_project/FifthComponent/post_titlebar.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: _MyPersistentHeader(),
          // ),

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

                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance.collection('space').doc('qqqqqqqqqqqqqqqq').get(),
                      builder: (context, snapshot) {
                        final imageUrl = snapshot.data!['image'];
                        final tag = snapshot.data!['tag'];
                        final location = snapshot.data!['location'];
                        // return Image.network(imageUrl);
                        return Image.network(imageUrl, width: 300, height: 300,);
                      },
                    ),

                    //여기부분에 데이터베이스에 저장된 것들 불러와줘.

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

// // 스크롤되지않게 고정해놓는 상속 함수
// class _MyPersistentHeader extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white, // Customize header color if needed
//       child: ExportSettings(), // Your ExportSettings widget
//     );
//   }
//
//   @override
//   double get maxExtent => 50.0; // Set the maximum height of the header
//   @override
//   double get minExtent => 50.0; // Set the minimum height of the header
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
// }
