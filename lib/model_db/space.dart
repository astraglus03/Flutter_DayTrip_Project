import 'package:intl/intl.dart';

class SpaceModel {
  final String spaceName;
  final String location;
  final String locationName;
  final String tag;
  final String image;
  String? exhibiTag;
  DateTime? exhibiDate;
  String? exhibiName;

  // 기본 생성자: 3개의 추가 필드(exhibiTag, exhibiDate, exhibiName) 제외
  SpaceModel({
    required this.spaceName,
    required this.location,
    required this.tag,
    required this.image,
    required this.locationName,
  });

  // 두 번째 생성자: 모든 필드 포함
  SpaceModel.full({
    required this.spaceName,
    required this.location,
    required this.tag,
    required this.image,
    required this.locationName,
    this.exhibiTag,
    this.exhibiDate,
    this.exhibiName,
  });

  SpaceModel.fromJson(Map<String, dynamic> json)
      : spaceName = json['spaceName'],
        location = json['location'],
        tag = json['tag'],
        image = json['image'],
        locationName = json['locationName'],
        exhibiTag = json['exhibi_tag'],
        exhibiDate = DateFormat('yyyy년 MM월 dd일').parse(json['exhibi_date']),
        exhibiName = json['exhibi_name'];

  Map<String, dynamic> toJson() {
    if (exhibiTag != null && exhibiDate != null && exhibiName != null) {
      return {
        'spaceName': spaceName,
        'location': location,
        'tag': tag,
        'image': image,
        'locationName': locationName,
        'exhibi_tag': exhibiTag,
        'exhibi_date': DateFormat('yyyy년 MM월 dd일').format(exhibiDate!),
        'exhibi_name': exhibiName,
      };
    } else {
      return {
        'spaceName': spaceName,
        'location': location,
        'tag': tag,
        'image': image,
        'locationName': locationName,
      };
    }
  }
}