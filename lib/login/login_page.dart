import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/login/kakao_login/kakao_login.dart';
import 'package:final_project/login/kakao_login/main_view_model.dart';
import 'package:final_project/login/login_button.dart';
import 'package:final_project/login/services/auth_service.dart';
import 'package:final_project/login/square_tile.dart';
import 'package:final_project/login/textfile.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({
    required this.onTap,
});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          // 키보드 올라올떄 overflow 막아줌
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.login,
                  size: 100,
                ),
                SizedBox(
                  height: 30,
                ),

                Text(
                  "로그인 페이지 입니다.",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                SizedBox(
                  height: 25,
                ),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: "ID",
                  obscureText: false,
                ),

                SizedBox(
                  height: 10,
                ),
                // password textfield
                MyTextField(
                  controller: pwController,
                  hintText: "Password",
                  obscureText: true,
                ),

                SizedBox(
                  height: 10,
                ),

                // forget password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "비밀번호를 잃어버리셨나요?",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 25,
                ),

                // sign in button
                MyButton(
                  onTap: login,
                  text: "로그인하기",
                ),

                SizedBox(
                  height: 25,
                ),
                // or continue with

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '다음으로 계속',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                // google + apple sign in buttons
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'asset/google.png',
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SquareTile(
                        imagePath: 'asset/naver.png',
                        onTap: () async {
                          await viewModel.login();
                        } ),
                    SizedBox(
                      width: 25,
                    ),
                    SquareTile(
                        imagePath: 'asset/kakao.png',
                        onTap: () async {
                          await viewModel.login();
                        } ),
                  ],
                ),

                // Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
                // not a member? register now
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "회원이 아니신가요?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "회원가입 하기",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    // 로딩 원 생성
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwController.text,
      );
      // 로딩 원 종료
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('파베'+e.code);
      // 로딩 원 종료
      Navigator.pop(context);
      // 이메일 틀렸을시
      //   if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      wrongmessage('이메일이나 비밀번호가 다릅니다.');
        // }
    }
  }

  // 이메일 오류 함수
  void wrongmessage(String message) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(message),
        );
      },
    );

    // 자동으로 AlertDialog 없애는 코드
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }
}
