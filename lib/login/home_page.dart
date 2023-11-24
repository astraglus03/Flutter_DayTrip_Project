import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart' as kakao;
import 'package:final_project/login/kakao_login/kakao_login.dart';
import 'package:final_project/login/kakao_login/main_view_model.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final viewModel = MainViewModel(KakaoLogin());

  HomePage({super.key});

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao User Check'),
      ),
      body: Center(
        child: user != null && user!.uid.contains('kakao')
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                  signUserOut();
                },
                child: Text("로그아웃")),

            Text(
              "카카오로 로그인 되었습니다. ${user!.displayName}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async{
                  signUserOut();
                },
                child: Text("로그아웃")),

            Text(
              "구글 로그인 되었습니다. ${user!.displayName}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )
        )
    );
  }
}
