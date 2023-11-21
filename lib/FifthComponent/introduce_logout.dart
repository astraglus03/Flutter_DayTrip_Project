import 'package:flutter/material.dart';

class IntroduceAndLogout extends StatelessWidget {
  const IntroduceAndLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){},
              child: Text("탭하고 소개 글을 입력해 보세요", style: TextStyle(
                color: Colors.grey[500],
              ),)
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: TextButton(
              onPressed: () {
               // 버튼 눌렀을때 이벤트 처리할 곳.
              },
              child: Text('로그아웃'),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.transparent,
                splashFactory: InkSplash.splashFactory,
                minimumSize: Size(80, 20),
              ),
            ),
          ),

        ],
      ),
    );
  }
}