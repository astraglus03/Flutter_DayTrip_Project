// 공간 추가 모델

import 'dart:ui';

class SpaceModel {
  final String spaceName;
  final String location; // 위도 경도
  final String locationName;
  final String tag;
  final String image;


  SpaceModel({
    required this.spaceName,
    required this.location,
    required this.tag,
    required this.image,
    required this.locationName,
  });

  SpaceModel.fromJson({ // ➊ JSON으로부터 모델을 만들어내는 생성자
    required Map<String, dynamic> json,
  })  : spaceName = json['spaceName'],
        location = json['location'],
        tag = json['tag'],
        image = json['image'],
        locationName = json['locationName'];

  Map<String, dynamic> toJson() {  // ➋ 모델을 다시 JSON으로 변환하는 함수
    return {
      'spaceName': spaceName,
      'location': location,
      'tag': tag,
      'image': image,
      'locationName': locationName,
    };
  }

  SpaceModel copyWith({  // ➌ 현재 모델을 특정 속성만 변환해서 새로 생성
    String? spaceName,
    String? location,
    String? tag,
    String? image,
    String? locationName,
    String? recom_tag,
  }) {
    return SpaceModel(
      spaceName: spaceName ?? this.spaceName,
      location: location ?? this.location,
      tag: tag ?? this.tag,
      image: image ?? this.image,
      locationName: locationName ?? this.locationName,
    );
  }


}