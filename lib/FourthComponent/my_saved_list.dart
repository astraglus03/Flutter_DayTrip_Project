import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPostList extends StatefulWidget {
  const SavedPostList({Key? key}) : super(key: key);

  @override
  State<SavedPostList> createState() => _SavedPostListState();
}

class _SavedPostListState extends State<SavedPostList> {
  late Stream<QuerySnapshot> likedPostsStream;

  @override
  void initState() {
    super.initState();
    fetchLikedPostsStream();
  }

  Future<void> fetchLikedPostsStream() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        likedPostsStream = FirebaseFirestore.instance
            .collectionGroup('post')
            .where('likes', arrayContains: uid)
            .snapshots();
      }
    } catch (error) {
      print('Error fetching liked posts stream: $error');
    }
  }

  Future<void> toggleLike(String pid) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the document reference for the post
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collectionGroup('post')
            .where('pid', isEqualTo: pid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> postDoc = querySnapshot.docs.first;
          DocumentReference postDocRef = postDoc.reference;

          bool isLiked = postDoc.get('likes').contains(uid);
          print("상태: ${isLiked}");
            // Remove user's UID from likes array
            await postDocRef.update({
              'likes': FieldValue.arrayRemove([uid]),
            });

        }
      }
    } catch (error) {
      print('Error toggling like: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "내 리스트",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "전체보기 >",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10),

        StreamBuilder<QuerySnapshot>(
          stream: likedPostsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // 로딩 중일 때의 UI
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 에러 발생 시 UI
            } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return SizedBox(
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
              ); // 데이터가 없을 때의 UI
            } else {
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display three items in a row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var postData = snapshot.data!.docs[index].data() as Map<String, dynamic>?;
                  print('포스트 데이터: ${postData}');
                  if (postData != null) {
                    return GestureDetector(
                      onTap: () {
                        // Handle item tap
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
                                    postData['image'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      postData['spaceName'] ?? '',
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
                              icon: postData['isLiked'] ?? true
                                  ? Icon(Icons.favorite, color: Colors.red)
                                  : Icon(Icons.favorite_border, color: Colors.red),
                              onPressed: () {
                                toggleLike(postData['pid'] ?? '');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(); // Return an empty SizedBox if postData is null
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }
}
