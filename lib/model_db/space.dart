import 'dart:ui';

class SpaceModel {
  final String spaceName; // 공간명
  final String location;  // 좌표
  final String tag;       // 태그
  final String image;     // 사진

  SpaceModel({
    required this.spaceName,
    required this.location,
    required this.tag,
    required this.image,
  });

  SpaceModel.fromJson({ // ➊ JSON으로부터 모델을 만들어내는 생성자
    required Map<String, dynamic> json,
  })  : spaceName = json['spaceName'],
        location = json['location'],
        tag = json['tag'],
        image = json['image'];

  Map<String, dynamic> toJson() {  // ➋ 모델을 다시 JSON으로 변환하는 함수
    return {
      'id': spaceName,
      'location': location,
      'tag': tag,
      'image': image,
    };
  }

  SpaceModel copyWith({  // ➌ 현재 모델을 특정 속성만 변환해서 새로 생성
    String? id,
    String? location,
    String? tag,
    String? image,
    String? recom_tag,
  }) {
    return SpaceModel(
      spaceName: spaceName ?? this.spaceName,
      location: location ?? this.location,
      tag: tag ?? this.tag,
      image: image ?? this.image,
    );
  }

}