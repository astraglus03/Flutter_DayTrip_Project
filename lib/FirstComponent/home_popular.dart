import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/FirstComponent/likeprovider.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePopular extends StatefulWidget {
  const HomePopular({Key? key}) : super(key: key);

  @override
  _HomePopularState createState() => _HomePopularState();
}

class _HomePopularState extends State<HomePopular> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LikedItemsProvider(),
    child: Scaffold(
    body: PostTab(),// DayLog 위젯을 여기에 추가
    ),
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

  List<PopularPostInfo> PopularPostInfoList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // 6개의 탭
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('인기 피드', style: TextStyle(color: Colors.white)),
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
                // print('정보: ${info}');
                bool isLiked = likedItemsList[tabIndex].contains(index);


                return GestureDetector(
                  onTap: () async {
                    var info = tabInfo[tabIndex][index];
                    String location = '';

                    QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
                        .collectionGroup('space')
                        .where('locationName', isEqualTo: info['locationName'])
                        .get();

                    if (spaceSnapshot.docs.isNotEmpty) {
                      location = spaceSnapshot.docs.first.get('location') ?? '';
                    }

                    String image = info['imagePath'] ?? '';
                    String locationName = info['locationName'] ?? '';
                    String spaceName = info['spaceName'] ?? '';
                    String tag = info['tag'] ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlaceBlogScreen(
                            image: image,
                            locationName: locationName,
                            spaceName: spaceName,
                            tag: tag,
                            location: location,
                          );
                        },
                      ),
                    );
                  },

                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 3.2,
                            margin: EdgeInsets.symmetric(horizontal: 0.5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(info['imagePath']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            info['spaceName'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          //Text(info['pid']),
                          Text(
                            info['locationName'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            toggleLike(info['pid'], isLiked,tabIndex);
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
                      Positioned(
                        top: 30,
                        right: 10,
                        child: Text("+${info['likesCount']}", style: TextStyle(
                          color: Colors.red,
                        ),),
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

  Stream<QuerySnapshot> getPostsStream() {
    final usersCollectionRef = FirebaseFirestore.instance.collection('users');
    return usersCollectionRef.snapshots(); // 변경 사항을 지속적으로 가져옴
  }
  @override
  void initState() {
    super.initState();
    getPostsStream().listen((QuerySnapshot querySnapshot) {
      fetchPopularPostModel(querySnapshot);
    });
  }

  Future<void> fetchPopularPostModel(QuerySnapshot querySnapshot) async {
    List<Set<int>> updatedLikedItemsList = List.generate(6, (_) => {});
    List<List<Map<String, dynamic>>> updatedTabInfo = List.generate(6, (_) => []);

    for (final userDoc in querySnapshot.docs) {
      final postCollectionRef = userDoc.reference.collection('post');
      final postQuerySnapshot = await postCollectionRef.get();

      for (final postDoc in postQuerySnapshot.docs) {
        final data = postDoc.data();
        String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
        String image = data.containsKey('image') ? data['image'] : '';
        String pid = data.containsKey('pid') ? data['pid'] : '';
        String tag = data.containsKey('tag') ? data['tag'] : '';
        String locationName =
        data.containsKey('locationName') ? data['locationName'] : '';
        String writtenTime =
        data.containsKey('writtenTime') ? data['writtenTime'] : '';

        int likesCount = 0;
        if (data.containsKey('likes')) {
          if (data['likes'] is List) {
            likesCount = data['likes'].length;
          }
        }


        // 0번 탭 - 전체 정보 가져오기
        if (writtenTime.isNotEmpty){
          updatedTabInfo[0].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        // 1번 탭 - 카페 정보 가져오기
        if((writtenTime.isNotEmpty) && tag == '카페') {
          updatedTabInfo[1].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        // 2번 탭 - 음식점 정보 가져오기
        if((writtenTime.isNotEmpty) && tag == '음식점') {
          updatedTabInfo[2].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        // 3번 탭 - 편의점 정보 가져오기
        if((writtenTime.isNotEmpty ) && tag == '편의점') {
          updatedTabInfo[3].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        // 4번 탭 - 학교 건물 정보 가져오기
        if((writtenTime.isNotEmpty) && tag == '학교건물') {
          updatedTabInfo[4].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        // 5번 탭 - 편의점 정보 가져오기
        if((writtenTime.isNotEmpty) && tag == '문화') {
          updatedTabInfo[5].add({
            'spaceName': spaceName,
            'imagePath': image,
            'pid': pid,
            'locationName' : locationName,
            'tag': tag,
            'likesCount': likesCount,
          });
        }

        updatedTabInfo.forEach((tab) {
          tab.sort((a, b) => b['likesCount'].compareTo(a['likesCount']));
        });
      }
    }

    setState(() {
      tabInfo.clear();
      tabInfo.addAll(updatedTabInfo);
      likedItemsList.clear();
      likedItemsList.addAll(updatedLikedItemsList);
    });
  }

  final List<List<Map<String, dynamic>>> tabInfo = [
    [], // 탭1
    [], // 탭2
    [], // 탭3
    [], // 탭4
    [], // 탭5
    [], // 탭6
  ];

  Future<void> toggleLike(String pid, bool isLiked, int tabIndex) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        final usersCollectionRef = FirebaseFirestore.instance.collection('users');
        final querySnapshot = await usersCollectionRef.get();

        for (final userDoc in querySnapshot.docs) {
          final postCollectionRef = userDoc.reference.collection('post');
          final postDoc = await postCollectionRef.doc(pid).get();

          if (postDoc.exists) {
            DocumentReference postDocRef = postDoc.reference;

            if (!isLiked) {
              await postDocRef.update({
                'likes': FieldValue.arrayUnion([uid]),
              });
              print("Liked post successfully");
            } else {
              await postDocRef.update({
                'likes': FieldValue.arrayRemove([uid]),
              });
              print("Unliked post successfully");
            }

            setState(() {
              updateSpecificTab(pid, isLiked, 1); // 1번탭: 카페
              updateSpecificTab(pid, isLiked, 2); // 2번탭: 음식점
              updateSpecificTab(pid, isLiked, 3); // 3번탭: 편의점
              updateSpecificTab(pid, isLiked, 4); // 4번탭: 학교 공간
              updateSpecificTab(pid, isLiked, 5); // 5번탭: 문화
              updateSpecificTab(pid, isLiked, 0); // 0번탭: 전체
            });


          }
        }
      } catch (error) {
        print('Error toggling like: $error');
      }
    }
  }

  void updateSpecificTab(String pid, bool isLiked, int tabIndex) {
    if (tabIndex >= 0 && tabIndex < tabInfo.length) {
      for (int i = 0; i < tabInfo[tabIndex].length; i++) {
        if (tabInfo[tabIndex][i]['pid'] == pid) {
          setState(() {
            isLiked ? likedItemsList[tabIndex].remove(i) : likedItemsList[tabIndex].add(i);

            // 좋아요 상태에 따라 likesCount 업데이트
            int currentLikesCount = tabInfo[tabIndex][i]['likesCount'];
            tabInfo[tabIndex][i]['likesCount'] = isLiked ? currentLikesCount - 1 : currentLikesCount + 1;
          });
          break;
        }
      }
    }
    // updateLikeCount(pid, isLiked, tabIndex);
  }


  // void updateLikeCount(String pid, bool isLiked, int tabIndex) {
  //   if (tabIndex >= 0 && tabIndex < tabInfo.length) {
  //     setState(() {
  //       for (int i = 0; i < tabInfo[tabIndex].length; i++) {
  //         if (tabInfo[tabIndex][i]['pid'] == pid) {
  //           int currentLikesCount = tabInfo[tabIndex][i]['likesCount'];
  //
  //           // 좋아요 누르면 likesCount가 증가하고, 취소하면 감소하도록 업데이트
  //           isLiked ? currentLikesCount-- : currentLikesCount++;
  //
  //           // 업데이트된 likesCount 적용
  //           tabInfo[tabIndex][i]['likesCount'] = currentLikesCount;
  //
  //           // 좋아요를 누르거나 취소할 때 해당 아이템의 likedItemsList에 인덱스를 추가하거나 제거
  //           isLiked ? likedItemsList[tabIndex].remove(i) : likedItemsList[tabIndex].add(i);
  //           break;
  //         }
  //       }
  //     });
  //   }
  // }

}
class PopularPostInfo{
  final String spaceName;
  final String image;
  final String pid;
  final String tag;
  final String locationName;
  final String writtenTime;

  PopularPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.tag,
    required this.locationName,
    required this.writtenTime,
  });
}
