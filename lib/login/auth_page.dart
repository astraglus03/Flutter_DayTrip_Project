import 'package:final_project/Screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/login/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // 로그인 안되어있을시
          if(snapshot.hasData){
            return MainScreen();
          }

          // 로그인 안되어있을시
          else
            return LoginOrRegisterPage();
        },

      ),
    );
  }
}
