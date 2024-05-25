import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Screen/main_screen.dart';
import 'package:final_project/model_db/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/login/login_or_register_page.dart';
import 'package:intl/intl.dart';

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
    final koreaCreateTime = await getUserKoreaTime(user.metadata.creationTime!);
    final koreaLastSignInTime = await getUserKoreaTime(user.metadata.lastSignInTime!);

    if (!userSnapshot.exists) {
      // 사용자 정보를 userModel로 변환
      final userModel = UserModel(
        displayName: user.displayName ?? '',
        image: user.photoURL ?? '',
        uid: currentUserUID,
        createTime: koreaCreateTime.toString(),
        lastSignInTime: koreaLastSignInTime.toString(),
      );

      // '사용자 정보' 문서에 사용자 정보 추가
      await userDocRef.set(userModel.toJson());

    } else {
      // 이미 사용자 정보가 존재하는 경우
      print('마지막 로그인 시간: ${koreaLastSignInTime}.');
      await userDocRef.update({
        'lastSignInTime': koreaLastSignInTime,
      });
    }
  }

  Future<String> getUserKoreaTime(DateTime utcTime) async {
    final koreaTimeZone = utcTime.toLocal(); // UTC 시간을 로컬 시간으로 변환
    final koreaTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(koreaTimeZone); // 원하는 형식으로 포맷
    return koreaTime;
  }

}