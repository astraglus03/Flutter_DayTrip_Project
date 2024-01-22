import 'package:final_project/FourthComponent/provider.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AllPostInfo {
  final String spaceName;
  final String image;
  final String pid;
  final String uid;
  final String tag;
  final String recomTag;
  final String date;
  final String postContent;
  final String locationName;
  bool isLiked;

  AllPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.uid,
    required this.tag,
    required this.recomTag,
    required this.date,
    required this.postContent,
    required this.locationName,
    required this.isLiked,
  });
}

class AllPostList extends StatefulWidget {
  AllPostList({Key? key}) : super(key: key);

  @override
  State<AllPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<AllPostList> {
  late List<AllPostInfo> allPostInfoList;
  //late LikeState likeState;

  @override
  void initState() {
    super.initState();
    allPostInfoList = [];
    //likeState = Provider.of<LikeState>(context, listen: false);
    fetchAllPostModel();
  }

  Future<void> toggleLike(String pid) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      int index = allPostInfoList.indexWhere((post) => post.pid == pid);
      if (index != -1) {
        bool isLiked = allPostInfoList[index].isLiked;

        try {
          QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
              .collectionGroup('post')
              .where('pid', isEqualTo: pid)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot<Map<String, dynamic>> postDoc = querySnapshot.docs.first;
            DocumentReference postDocRef = postDoc.reference;

            if (!isLiked) {
              await postDocRef.update({
                'likes': FieldValue.arrayUnion([uid]),
              });
              //likeState.toggleLike(pid); // 좋아요 상태 변경
              setState(() {
                allPostInfoList[index].isLiked = true;
              });
              print("Liked post successfully");
            } else {
              await postDocRef.update({
                'likes': FieldValue.arrayRemove([uid]),
              });
              //likeState.toggleLike(pid); // 좋아요 상태 변경
              setState(() {
                allPostInfoList[index].isLiked = false;
              });
              print("Unliked post successfully");
            }
          }
        } catch (error) {
          print('Error toggling like: $error');
        }
      }
    }
  }

  Future<void> fetchAllPostModel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      try {
        QuerySnapshot<Map<String, dynamic>> usersQuerySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

        for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in usersQuerySnapshot.docs) {
          QuerySnapshot<Map<String, dynamic>> postQuerySnapshot =
          await userDoc.reference.collection('post').get();

          List<AllPostInfo> updatedAllPostInfoList = postQuerySnapshot.docs.map((postDoc) {
            Map<String, dynamic> data = postDoc.data();
            String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
            String image = data.containsKey('image') ? data['image'] : '';
            String pid = data.containsKey('pid') ? data['pid'] : '';
            String uid = data.containsKey('uid') ? data['uid'] : '';
            String tag = data.containsKey('tag') ? data['tag'] : '';
            String recomTag = data.containsKey('recomTag') ? data['recomTag'] : '';
            String date = data.containsKey('date') ? data['date'] : '';
            String postContent = data.containsKey('postContent') ? data['postContent'] : '';
            String locationName = data.containsKey('locationName') ? data['locationName'] ?? '' : '';
            //여기서 likes에 있는 값도 가져와야 함.
            List<String> likes = data.containsKey('likes') ? List<String>.from(data['likes']) : [];
            bool isLiked = likes.contains(user!.uid);
            //bool isLiked = likeState.likedPostIds.contains(pid);

            return AllPostInfo(
              spaceName: spaceName,
              image: image,
              pid: pid,
              uid: uid,
              tag: tag,
              recomTag: recomTag,
              date: date,
              postContent: postContent,
              locationName: locationName,
              isLiked: isLiked,
            );
          }).toList();

          if (mounted) {
            setState(() {
              allPostInfoList.addAll(updatedAllPostInfoList);
            });
          }
        }
      } catch (error) {
        print('Error fetching posts: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "게시물 둘러보기",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 6.0,
            runSpacing: 8.0,
            children: allPostInfoList.asMap().entries.map((entry) {
              AllPostInfo postInfo = entry.value;
              print("포스트인포:${postInfo}");
              return GestureDetector(
                onTap: () async {
                  String location = '';

                  QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
                      .collectionGroup('space')
                      .where('locationName', isEqualTo: postInfo.locationName)
                      .get();

                  if (spaceSnapshot.docs.isNotEmpty) {
                    location = spaceSnapshot.docs.first.get('location') ?? '';
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlaceBlogScreen(
                          image: postInfo.image,
                          locationName: postInfo.locationName,
                          spaceName: postInfo.spaceName,
                          tag: postInfo.tag,
                          location: location,
                        );
                      },
                    ),
                  );
                },
                child: Stack(
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
                    Positioned(
                      top: -5,
                      right: -5,
                      child: IconButton(
                        icon: postInfo.isLiked
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () {
                          toggleLike(postInfo.pid);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}