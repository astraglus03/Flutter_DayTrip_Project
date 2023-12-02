class UserModel {
  final String displayName; // 로그인 되었을 때 이름
  final String image; // 사용자 배경화면
  final String uid; // 유저 아이디
  final String createTime; // 계정생성시간
  final String lastSignInTime; // 마지막 로그인 시간

  UserModel({
    required this.displayName,
    required this.image,
    required this.uid,
    required this.createTime,
    required this.lastSignInTime,
  });

  UserModel.fromJson({ // ➊ JSON으로부터 모델을 만들어내는 생성자
    required Map<String, dynamic> json,
  })  : displayName = json['displayName'],
        image = json['image'],
        uid = json['uid'],
        createTime = json['createTime'],
        lastSignInTime = json['lastSignInTime'];

  Map<String, dynamic> toJson() {  // ➋ 모델을 다시 JSON으로 변환하는 함수
    return {
      'displayName': displayName,
      'image': image,
      'uid': uid,
      'createTime': createTime,
      'lastSignInTime': lastSignInTime,
    };
  }
}