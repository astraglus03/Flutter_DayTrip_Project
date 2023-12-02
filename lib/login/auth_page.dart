import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Screen/main_screen.dart';
import 'package:final_project/model_db/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/login/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 로그인 되어있을 때
          if (snapshot.hasData) {
            final User? user = snapshot.data;

            // 사용자 정보가 있다면 Firestore에 저장하고 MainScreen 반환
            if (user != null) {
              saveUserInfoToFirestore(user);
              return MainScreen();
            }

            // 사용자 정보가 없다면 아무것도 반환하지 않고 기본 페이지로 이동
            return LoginOrRegisterPage();
          }

          // 로그인 안되어있을 때
          return LoginOrRegisterPage();
        },
      ),
    );
  }

  Future<void> saveUserInfoToFirestore(User user) async {
    final currentUserUID = user.uid;
    final userRef = FirebaseFirestore.instance.collection('users');

    // 사용자 정보를 저장할 문서에 접근
    final userDocRef = userRef.doc(currentUserUID);

    final userSnapshot = await userDocRef.get();

    if (!userSnapshot.exists) {
      // 사용자 정보를 userModel로 변환
      final userModel = UserModel(
        displayName: user.displayName ?? '',
        image: user.photoURL ?? '',
        uid: currentUserUID,
        createTime: user.metadata.creationTime.toString(),
        lastSignInTime: user.metadata.lastSignInTime.toString(),
      );

      // '사용자 정보' 문서에 사용자 정보 추가
      await userDocRef.set(userModel.toJson());

    } else {
      // 이미 사용자 정보가 존재하는 경우
      print('사용자 정보가 이미 존재합니다.');
    }
  }

}