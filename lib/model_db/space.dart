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

  SpaceModel({
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
    return {
      'spaceName': spaceName,
      'location': location,
      'tag': tag,
      'image': image,
      'locationName': locationName,
      'exhibi_tag': exhibiTag,
      'exhibi_date': exhibiDate != null ? DateFormat('yyyy년 MM월 dd일').format(exhibiDate!) : null,
      'exhibi_name': exhibiName,
    };
  }

  SpaceModel copyWith({
    String? spaceName,
    String? location,
    String? tag,
    String? image,
    String? locationName,
    String? exhibiTag,
    DateTime? exhibiDate,
    String? exhibiName,
  }) {
    return SpaceModel(
      spaceName: spaceName ?? this.spaceName,
      location: location ?? this.location,
      tag: tag ?? this.tag,
      image: image ?? this.image,
      locationName: locationName ?? this.locationName,
      exhibiTag: exhibiTag ?? this.exhibiTag,
      exhibiDate: exhibiDate ?? this.exhibiDate,
      exhibiName: exhibiName ?? this.exhibiName,
    );
  }
}
