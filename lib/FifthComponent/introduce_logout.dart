import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart' as kakao;
import 'package:final_project/login//kakao_login/kakao_login.dart';
import 'package:final_project/login/kakao_login/main_view_model.dart';

class IntroduceAndLogout extends StatelessWidget {

  IntroduceAndLogout({super.key});

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          ProfileTile(),

          SizedBox(height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 내 계정 프로필

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
                   // signUserOut();
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
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          // 카드 이미지
          CardImage(),

          SizedBox(width: 15,),

          // 이름, 친구수
          ProfileName(),

          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50)
      ),
      child: Container(
          child: Image.asset('asset/apple.jpg', fit: BoxFit.cover, width: 80, height: 80,)
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  // final user = FirebaseAuth.instance.currentUser!;
  // final viewModel = MainViewModel(KakaoLogin());

  ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ${user.displayName}
        Text("astraglus", style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),),
        SizedBox(height: 5,),
        Text("팔로워 0 | 팔로잉 0"),
      ],
    );
  }
}