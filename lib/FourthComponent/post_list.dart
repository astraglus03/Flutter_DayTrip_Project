import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/FourthComponent/save_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AllPostInfo{
  final String spaceName;
  final String image;
  final String pid;

  AllPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
  });
}


class AllPostList extends StatefulWidget {
  AllPostList({Key? key}) : super(key: key);

  @override
  State<AllPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<AllPostList> {
  late SaveClass mySavedList;
  List<AllPostInfo> allPostInfoList = [];

  @override // SaveClass 인스턴스 초기화
  void initState() {
    super.initState();
    mySavedList = Provider.of<SaveClass>(context, listen: false);
    fetchAllPostModel();
  }

  Future<void> fetchAllPostModel() async {

    FirebaseFirestore.instance
        .collection('post')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      List<AllPostInfo> updatedAllPostInfoList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
        String image = data.containsKey('image') ? data['image']: '';
        String pid = data.containsKey('pid') ? data['pid'] : '';

        return AllPostInfo(
          spaceName: spaceName,
          image: image,
          pid: pid,
        );
      }).toList();

      setState(() {
        allPostInfoList = updatedAllPostInfoList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaveClass>(
        builder: (context, saveClass, _) {
          return Column(
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
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                          icon: saveClass.savedItems.any((item) =>
                          item['spaceName'] == postInfo.spaceName &&
                              item['isLiked'])
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              bool isLiked = saveClass.savedItems.any((item) =>
                              item['spaceName'] == postInfo.spaceName &&
                                  item['isLiked']);
                              mySavedList.toggleLike(
                                !isLiked,
                                postInfo.pid,
                                postInfo.image,
                                postInfo.spaceName,
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        },
    );
  }
}