import 'package:flutter/material.dart';

class SpaceInfo {
  final String imagePath;
  final String title;
  final String location;

  SpaceInfo({
    required this.imagePath,
    required this.title,
    required this.location,
  });
}

class ChooseSpace extends StatefulWidget {
  @override
  State<ChooseSpace> createState() => _ChooseSpaceState();
}

class _ChooseSpaceState extends State<ChooseSpace> {
  final List<SpaceInfo> spaceInfoList = [
    SpaceInfo(
      imagePath: 'asset/google.png',
      title: '신세계 백화점',
      location: '충청남도 천안시 동남구 신부동',
    ),
    SpaceInfo(
      imagePath: 'asset/kakao.png',
      title: '동춘옥',
      location: '충청남도 천안시 동남구 멍청이',
    ),
    SpaceInfo(
      imagePath: 'asset/github.png',
      title: '이슬목장',
      location: '충청남도 천안시 동남구 이슬목장',
    ),
    SpaceInfo(
      imagePath: 'asset/google.png',
      title: '신세계 백화점',
      location: '충청남도 천안시 동남구 신부동',
    ),
    SpaceInfo(
      imagePath: 'asset/kakao.png',
      title: '동춘옥',
      location: '충청남도 천안시 동남구 멍청이',
    ),
    SpaceInfo(
      imagePath: 'asset/github.png',
      title: '이슬목장',
      location: '충청남도 천안시 동남구 이슬목장',
    ),
    SpaceInfo(
      imagePath: 'asset/google.png',
      title: '신세계 백화점',
      location: '충청남도 천안시 동남구 신부동',
    ),
    SpaceInfo(
      imagePath: 'asset/kakao.png',
      title: '동춘옥',
      location: '충청남도 천안시 동남구 멍청이',
    ),
    SpaceInfo(
      imagePath: 'asset/github.png',
      title: '이슬목장',
      location: '충청남도 천안시 동남구 이슬목장',
    ),
    SpaceInfo(
      imagePath: 'asset/google.png',
      title: '신세계 백화점',
      location: '충청남도 천안시 동남구 신부동',
    ),
    SpaceInfo(
      imagePath: 'asset/kakao.png',
      title: '동춘옥',
      location: '충청남도 천안시 동남구 멍청이',
    ),
    SpaceInfo(
      imagePath: 'asset/github.png',
      title: '이슬목장',
      location: '충청남도 천안시 동남구 이슬목장',
    ),
    SpaceInfo(
      imagePath: 'asset/google.png',
      title: '신세계 백화점',
      location: '충청남도 천안시 동남구 신부동',
    ),
    SpaceInfo(
      imagePath: 'asset/kakao.png',
      title: '동춘옥',
      location: '충청남도 천안시 동남구 멍청이',
    ),
    SpaceInfo(
      imagePath: 'asset/github.png',
      title: '이슬목장',
      location: '충청남도 천안시 동남구 이슬목장',
    ),
  ];

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공간 추가'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            // 서치바 있는 곳
            Container(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  // 검색 기능 구현
                },
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),

            SizedBox(height: 10,),

            Expanded(
              child: ListView.builder(
                itemCount: spaceInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Pass both imagePath and title to WriteOneLine
                      SpaceInfo selectedSpace = SpaceInfo(
                        imagePath: spaceInfoList[index].imagePath,
                        title: spaceInfoList[index].title,
                        location: spaceInfoList[index].location,
                      );
                      Navigator.pop(context, selectedSpace);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              spaceInfoList[index].imagePath,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spaceInfoList[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  spaceInfoList[index].location,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
