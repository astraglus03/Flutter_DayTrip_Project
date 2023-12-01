import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneLineInfo {
  final String spaceName;
  final String date;
  final String locationName;
  final String tag;

  OneLineInfo({
    required this.spaceName,
    required this.date,
    required this.locationName,
    required this.tag,
  });
}

class MyPostInfo{
  final String spaceName;
  final String image;

  MyPostInfo({
    required this.spaceName,
    required this.image,
  });
}

class DayLog extends StatefulWidget {
  const DayLog({Key? key}) : super(key: key);

  @override
  State<DayLog> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  bool selectedMyPost = false;
  bool selectedTimeLine = true;

  List<OneLineInfo> oneLineInfoList = [];
  List<MyPostInfo>  MyPostInfoList =[];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchoneLineModel();
    await fetchPostModel();
  }

  Future<void> fetchoneLineModel() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('oneLine')
        .where('uid', isEqualTo: currentUserUID)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<OneLineInfo> updatedOneLineInfoList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
        String date = data.containsKey('date') ? data['date'] : '';
        String locationName = data.containsKey('locationName') ? data['locationName'] : '';
        String tag = data.containsKey('tag') ? data['tag'] : '';

        return OneLineInfo(
          spaceName: spaceName,
          date: date,
          locationName: locationName,
          tag: tag,
        );
      }).toList();

      setState(() {
        oneLineInfoList = updatedOneLineInfoList;
      });
    });
  }


  Future<void> fetchPostModel() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('post')
        .where('uid', isEqualTo: currentUserUID)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<MyPostInfo> updatedMyPostInfoList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
        String image = data.containsKey('image') ? data['image']: '';

        // String date = data.containsKey('date') ? data['date'] : '';
        // String locationName = data.containsKey('locationName') ? data['locationName'] : '';
        // String tag = data.containsKey('tag') ? data['tag'] : '';

        return MyPostInfo(
          spaceName: spaceName,
          image: image,
        );
      }).toList();

      setState(() {
        MyPostInfoList = updatedMyPostInfoList;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMyPost = true;
                    selectedTimeLine = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_outlined,
                      color: selectedMyPost ? Colors.black : Colors.grey,
                    ),
                    Text(
                      "내가 올린 게시물",
                      style: TextStyle(
                        color: selectedMyPost ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text("  |  "),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMyPost = false;
                    selectedTimeLine = true;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: selectedTimeLine ? Colors.black : Colors.grey,
                    ),
                    Text(
                      "한줄평 타임라인",
                      style: TextStyle(
                        color: selectedTimeLine ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),

        if (selectedMyPost)
           MyPostList(postList: MyPostInfoList),

        if (selectedTimeLine)
          Column(
            children: oneLineInfoList.map((info) {
              return Column(
                children: [
                  MyWrittenPost(postInfo: info),
                  SizedBox(height: 10,),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}

class MyPostList extends StatelessWidget {
  final List<MyPostInfo> postList;

  const MyPostList({
    required this.postList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        postList.isEmpty
            ? SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(
            child: Text(
              '현재 내가 저장한 게시글이 없습니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
            : Wrap(
          spacing: 6.0,
          runSpacing: 8.0,
          children: postList.map((postInfo) {
            return PostItem(postInfo: postInfo);
          }).toList(),
        ),
      ],
    );
  }
}

class PostItem extends StatelessWidget {
  final MyPostInfo postInfo;

  const PostItem({
    required this.postInfo,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SizedBox(
          width: 133,
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  postInfo.image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    postInfo.spaceName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class MyWrittenPost extends StatelessWidget {
  final OneLineInfo postInfo;

  const MyWrittenPost({
    required this.postInfo,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(postInfo.date));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((16)),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(formattedDate),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${postInfo.spaceName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '| ${postInfo.tag}', style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          Text(
                            '${postInfo.locationName}', style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // IconButton(
                  //   onPressed: (){},
                  //   icon: Icon(
                  //     Icons.more_horiz,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}