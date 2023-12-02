// 데이로그 작성 모델

import 'dart:ui';

import 'package:intl/intl.dart';

class PostModel {
  final String pid;            // 게시물 id
  final String uid;         // 사용자id
  final String postContent; // 게시물 내용
  final String image;       // 게시물 사진
  final String spaceName;   // 공간 이름
  final DateTime date;      // 작성 날짜
  final String tag;         // 태그
  final String recomTag;    // 추천 태그
  final int good;           // 좋아요

  PostModel({
    required this.pid,
    required this.uid,
    required this.postContent,
    required this.image,
    required this.spaceName,
    required this.date,
    required this.tag,
    required this.recomTag,
    required this.good,
  });

  PostModel.fromJson({ // ➊ JSON으로부터 모델을 만들어내는 생성자
    required Map<String, dynamic> json,
  })  : pid = json['pid'],
        uid = json['uid'],
        postContent = json['postContent'],
        image = json['image'],
        spaceName = json['spaceName'],
        date = DateFormat('yyyy년 MM월 dd일').parse(json['date']),
        tag = json['tag'],
        recomTag = json['recomTag'],
        good = json['good']; //bool은 다르게 처리 //good = json['good'] as bool;

  Map<String, dynamic> toJson() {  // ➋ 모델을 다시 JSON으로 변환하는 함수
    return {
      'pid': pid,
      'uid': uid,
      'postContent': postContent,
      'image': image,
      'spaceName' : spaceName,
      'date': DateFormat('yyyy년 MM월 dd일').format(date),
      'tag' : tag,
      'recomTag' : recomTag,
      'good' : good,
    };
  }

  PostModel copyWith({  // ➌ 현재 모델을 특정 속성만 변환해서 새로 생성
    String? pid,
    String? uid,
    // String? postName,
    String? postContent,
    String? image,
    String? spaceName,
    DateTime? date,
    String? tag,
    String? recomTag,
    int? good,
  }) {
    return PostModel(
        pid: pid ?? this.pid,
        uid: uid ?? this.uid,
        // postName: postName ?? this.postName,
        postContent: postContent ?? this.postContent,
        image: image ?? this.image,
        spaceName: spaceName ?? this.spaceName,
        date: date ?? this.date,
        tag: tag ?? this.tag,
        recomTag: recomTag ?? this.recomTag,
        good: good ?? this.good
    );
  }

}