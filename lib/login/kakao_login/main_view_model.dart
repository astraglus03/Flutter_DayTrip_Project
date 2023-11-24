import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:final_project/login/kakao_login/social_login.dart';
import 'package:final_project/login/services/auth_service.dart';


class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false; //처음에 로그인 안 되어 있음
  kakao.User? user; //카카오톡에서 사용자 정보를 저장하는 객체 User를 nullable 변수로 선언

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login(); //로그인되어 있는지 확인
    if(isLogined){
      user = await kakao.UserApi.instance.me(); //사용자 정보 받아오기

      if(user != null){
        print("로그인 성공 ${user!.kakaoAccount}");
        print("사용자 정보: $user");
      }
      else{
        print("사용자 정보가 null입니다.");
      }

      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid' : user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);

    }
    else
      print("로그인 실패");
  }
  Future logout() async {
    print("로그아웃하기전에 정보 ${user!.kakaoAccount}");
    await _socialLogin.logout(); //로그아웃 실행
    await FirebaseAuth.instance.signOut();
    isLogined = false; //로그인되어 있는지를 저장하는 변수 false값 저장
    user = null; //user 객체 null
  }
}