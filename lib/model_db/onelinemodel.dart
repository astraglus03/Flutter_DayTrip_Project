// 한 줄 평 모델

import 'dart:ui';

class OneLineModel {
  final int oid;            // 한 줄 평 id
  final String uid;         // 사용자id
  final DateTime date;      // 작성 날짜
  final String spaceName;   // 공간 이름
  final String tag;         // 태그
  final String oneLineContent; // 한줄 평
  final String locationName; // 지역 이름 ex) 충청남도 천안시 동남구 신부동 321-5

  OneLineModel({
    required this.oid,
    required this.uid,
    required this.date,
    required this.spaceName,
    required this.tag,
    required this.oneLineContent,
    required this.locationName,
  });

  OneLineModel.fromJson({ // ➊ JSON으로부터 모델을 만들어내는 생성자
    required Map<String, dynamic> json,
  })  : oid = json['oid'],
        uid = json['uid'],
        date = DateTime.parse(json['date']),
        spaceName = json['spaceName'],
        tag = json['tag'],
        oneLineContent = json['oneLineContent'],
        locationName = json['locationName'];

  Map<String, dynamic> toJson() {  // ➋ 모델을 다시 JSON으로 변환하는 함수
    return {
      'oid': oid,
      'uid': uid,
      'date':
      '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      'spaceName' : spaceName,
      'tag' : tag,
      'oneLineContent' : oneLineContent,
      'locationName' : locationName,
    };
  }

  OneLineModel copyWith({  // ➌ 현재 모델을 특정 속성만 변환해서 새로 생성
    int? oid,
    String? uid,
    DateTime? date,
    String? spaceName,
    String? tag,
    String? oneLineContent,
    String? locationName,
  }) {
    return OneLineModel(
      oid: oid ?? this.oid,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      spaceName: spaceName ?? this.spaceName,
      tag: tag ?? this.tag,
      oneLineContent: oneLineContent ?? this.oneLineContent,
      locationName: locationName ?? this.locationName,
    );
  }


}