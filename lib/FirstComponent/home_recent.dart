import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HomeRecent extends StatefulWidget {
  const HomeRecent({Key? key}) : super(key: key);

  @override
  _HomeRecentState createState() => _HomeRecentState();
}

class _HomeRecentState extends State<HomeRecent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostTab(), // DayLog 위젯을 여기에 추가
    );
  }
}

// 전체적인 포스트 탭 보여주기
class PostTab extends StatefulWidget {
  const PostTab({Key? key}) : super(key: key);

  @override
  State<PostTab> createState() => _PostTabState();

}

class _PostTabState extends State<PostTab> {
  int _currentIndex = 0;
  List<Set<int>> likedItemsList = List.generate(6, (_) => {});

  List<String> recentImagePaths = [];
  List<RecentPostInfo> recentPostInfoList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6, // 6개의 탭
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              title: Text('최신 피드', style: TextStyle(color: Colors.white)),
              //backgroundColor: Colors.black,
              bottom: TabBar(
                tabs: [
                  Tab(text: '전체'),
                  Tab(text: '카페'),
                  Tab(text: '음식점'),
                  Tab(text: '편의점'),
                  Tab(text: '학교건물'),
                  Tab(text: '문화'),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          body: TabBarView(
            children: List.generate(
              tabInfo.length,
                  (tabIndex) => GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                  mainAxisExtent: 340,
                  childAspectRatio: 0.5,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: tabInfo[tabIndex].length,
                itemBuilder: (BuildContext context, int index) {
                  var info = tabInfo[tabIndex][index];
                  bool isLiked = likedItemsList[tabIndex].contains(index);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceBlogScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 3,
                              margin: EdgeInsets.symmetric(horizontal: 0.5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(info['imagePath']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(info['spaceName']),
                            //Text(info['pid']),
                            Text(info['locationName']),
                          ],
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isLiked) {
                                  likedItemsList[tabIndex].remove(index);
                                } else {
                                  likedItemsList[tabIndex].add(index);
                                }
                              });
                            },
                            child: Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
    );
  }

  @override // SaveClass 인스턴스 초기화
  void initState() {
    super.initState();
    fetchRecentPostModel();
  }

  Future<void> fetchRecentPostModel() async {
    final usersCollectionRef = FirebaseFirestore.instance.collection('users');

    List<Set<int>> updatedLikedItemsList = List.generate(6, (_) => {});
    List<List<Map<String, dynamic>>> updatedTabInfo = List.generate(6, (_) => []);

    final querySnapshot = await usersCollectionRef.get();

    for (final userDoc in querySnapshot.docs) {
      final postCollectionRef = userDoc.reference.collection('post');

      final postQuerySnapshot = await postCollectionRef.get();
      for (final postDoc in postQuerySnapshot.docs) {
        final data = postDoc.data();
        String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
        String image = data.containsKey('image') ? data['image'] : '';
        String pid = data.containsKey('pid') ? data['pid'] : '';
        String tag = data.containsKey('tag') ? data['tag'] : '';
        String locationName = data.containsKey('locationName') ? data['locationName'] : '';
        String writtenTime = data.containsKey('writtenTime') ? data['writtenTime'] : '';

        // 0번 탭 - 전체 정보 가져오기
        if (writtenTime.isNotEmpty && _isToday(writtenTime)){
          updatedTabInfo[0].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }

        // 1번 탭 - 카페 정보 가져오기
        if((writtenTime.isNotEmpty && _isToday(writtenTime)) && tag == '카페') {
          updatedTabInfo[1].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }

        // 2번 탭 - 음식점 정보 가져오기
        if((writtenTime.isNotEmpty && _isToday(writtenTime)) && tag == '음식점') {
          updatedTabInfo[2].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }

        // 3번 탭 - 편의점 정보 가져오기
        if((writtenTime.isNotEmpty && _isToday(writtenTime)) && tag == '편의점') {
          updatedTabInfo[3].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }

        // 4번 탭 - 학교 건물 정보 가져오기
        if((writtenTime.isNotEmpty && _isToday(writtenTime)) && tag == '학교건물') {
          updatedTabInfo[4].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }

        // 5번 탭 - 편의점 정보 가져오기
        if((writtenTime.isNotEmpty && _isToday(writtenTime)) && tag == '문화') {
          updatedTabInfo[5].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
          });
        }
      }
    }

    setState(() {
      tabInfo.clear();
      tabInfo.addAll(updatedTabInfo);
      likedItemsList.clear();
      likedItemsList.addAll(updatedLikedItemsList);
    });
  }

  bool _isToday(String writtenTime) {
    final now = DateTime.now();
    final parsedTime = DateFormat('yyyy/MM/dd - HH:mm:ss').parse(writtenTime);

    // Compare the year, month, and day of both dates
    return now.year == parsedTime.year &&
        now.month == parsedTime.month &&
        now.day == parsedTime.day;
  }

  final List<List<Map<String, dynamic>>> tabInfo = [
    [], // 탭1
    [], // 탭2
    [], // 탭3
    [], // 탭4
    [], // 탭5
    [], // 탭6
  ];
}

class RecentPostInfo{
  final String spaceName;
  final String image;
  final String pid;
  final String tag;
  final String locationName;
  final String writtenTime;

  RecentPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.tag,
    required this.locationName,
    required this.writtenTime,
  });
}
