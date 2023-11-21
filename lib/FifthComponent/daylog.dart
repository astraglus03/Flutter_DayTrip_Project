import 'package:flutter/material.dart';

class DayLog extends StatefulWidget {

  const DayLog({super.key});

  @override
  State<DayLog> createState() => _DayLogState();
}

class _DayLogState extends State<DayLog> {
  bool SelectedMyPost = false;
  bool SelectedTimeLine = true;

  List<Map<String, dynamic>> postsInfo = [
    {
      'title': '강변서재',
      'location': '서울, 영등포구',
      'category': '카페',
    },

    {
      'title': '다른 게시물',
      'location': '위치',
      'category': '카테고리',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),

        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  // 이벤트 처리할 곳
                  setState(() {
                    SelectedMyPost = true;
                    SelectedTimeLine = false;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_outlined,
                      color: SelectedMyPost ? Colors.black : Colors.grey,
                    ),
                    Text("내가 올린 게시물",style: TextStyle(
                      color: SelectedMyPost ? Colors.black : Colors.grey,
                    ),),
                  ],
                ),
              ),

              Text("  |  "),

              GestureDetector(
                onTap: (){
                  // 이벤트 처리할 곳
                  setState(() {
                    SelectedMyPost = false;
                    SelectedTimeLine = true;
                  });
                },
                child: Row(
                  children:[
                    Icon(
                      Icons.calendar_today,
                      color: SelectedTimeLine ? Colors.black : Colors.grey,
                    ),
                    Text("한줄평 타임라인", style: TextStyle(
                      color: SelectedTimeLine ? Colors.black : Colors.grey,
                    ),),
                  ]
                ),
              ),
            ],
          ),
        ),

        //
        if(SelectedMyPost)
          MyPostList(),

        if(SelectedTimeLine)
          Column(
            children: postsInfo.map((post) {
              return MyWrittenPost(postInfo: post);
            }).toList(),
          ),

        // here i want to locate
      ],
    );
  }
}

class MyPostList extends StatefulWidget {

  MyPostList({super.key});

  @override
  State<MyPostList> createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  bool isLiked = false;
  final List<String> assetImages = [
    'asset/github.png',
    'asset/apple.jpg',
    'asset/apple.jpg',
    'asset/google.png',
    'asset/apple.jpg',
    'asset/google.png',
    'asset/google.png',
    'asset/github.png',
    'asset/apple.jpg',
    'asset/apple.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),

        Wrap(
          spacing: 6.0,
          runSpacing: 8.0,
          children: assetImages.isEmpty
              ? [
            SizedBox(
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
            ),
          ]
              : assetImages.map((path) {
            String imageName = path.split('/').last.split('.').first;

            return Stack(
              children: [
                SizedBox(
                  width: 133,
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          path,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            imageName,
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
          }).toList(),
        ),
      ],
    );
  }
}


class MyWrittenPost extends StatelessWidget {

  const MyWrittenPost({
    required this.postInfo,
});

  final Map<String, dynamic> postInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text("2023년 11월 20일 (월)"),
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
                        Text(
                          postInfo['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${postInfo['location']} | ${postInfo['category']}",
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 5,),
        ],
      ),
    );
  }
}
