import 'package:intl/intl.dart';

class SpaceModel {
  final String spaceName;
  final String location; // 위도 경도
  final String locationName;
  final String tag;
  final String image;
  //final String? recom_tag; // 추가된 부분
  final String? exhibi_tag; // 추가된 부분
  final DateTime? exhibi_date; // 추가된 부분
  final String? exhibi_name; // 추가된 부분

  SpaceModel({
    required this.spaceName,
    required this.location,
    required this.tag,
    required this.image,
    required this.locationName,
    //this.recom_tag,
    this.exhibi_tag,
    this.exhibi_date,
    this.exhibi_name,
  });

  SpaceModel.fromJson(Map<String, dynamic> json)
      : spaceName = json['spaceName'],
        location = json['location'],
        tag = json['tag'],
        image = json['image'],
        locationName = json['locationName'],
        //recom_tag = json['recom_tag'], // 업데이트된 부분
        exhibi_tag = json['exhibi_tag'], // 업데이트된 부분
        exhibi_date = DateFormat('yyyy년 MM월 dd일').parse(json['exhibi_date']),
        exhibi_name = json['exhibi_name']; // 업데이트된 부분

  Map<String, dynamic> toJson() {
    return {
      'spaceName': spaceName,
      'location': location,
      'tag': tag,
      'image': image,
      'locationName': locationName,
      //'recom_tag': recom_tag, // 업데이트된 부분
      'exhibi_tag': exhibi_tag, // 업데이트된 부분
      'exhibi_date': DateFormat('yyyy년 MM월 dd일').format(exhibi_date!), // 업데이트된 부분
      'exhibi_name': exhibi_name, // 업데이트된 부분
    };
  }

  SpaceModel copyWith({
    String? spaceName,
    String? location,
    String? tag,
    String? image,
    String? locationName,
    //String? recom_tag,
    String? exhibi_tag,
    DateTime? exhibi_date,
    String? exhibi_name,
  }) {
    return SpaceModel(
      spaceName: spaceName ?? this.spaceName,
      location: location ?? this.location,
      tag: tag ?? this.tag,
      image: image ?? this.image,
      locationName: locationName ?? this.locationName,
      exhibi_tag: exhibi_tag ?? this.exhibi_tag, // 업데이트된 부분
      exhibi_date: exhibi_date ?? this.exhibi_date, // 업데이트된 부분
      exhibi_name: exhibi_name ?? this.exhibi_name, // 업데이트된 부분
    );
  }
}
