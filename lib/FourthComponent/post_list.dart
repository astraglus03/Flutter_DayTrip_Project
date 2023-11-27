import 'package:final_project/FourthComponent/save_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late SaveClass mySavedList;
  // late List<bool> likedList;

  final List<String> assetImages = [
    'asset/github.png',
    'asset/apple.jpg',
    'asset/google.png',
    'asset/apple.jpg',
    'asset/apple.jpg',
    'asset/github.png',
    'asset/apple.jpg',
    'asset/google.png',
    'asset/apple.jpg',
    'asset/apple.jpg',
    'asset/github.png',
    'asset/apple.jpg',
    'asset/google.png',
    'asset/apple.jpg',
    'asset/apple.jpg',
  ];

  @override
  void initState() {
    super.initState();
    mySavedList = Provider.of<SaveClass>(context, listen: false); // SaveClass 인스턴스 초기화
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
                children: List.generate(assetImages.length, (index) {
                  String path = assetImages[index];
                  String imageName = path
                      .split('/')
                      .last
                      .split('.')
                      .first;

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
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                          icon: saveClass.savedItems.any((item) =>
                          item['index'] == index && item['isLiked'])
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              bool isLiked = saveClass.savedItems.any((item) =>
                              item['index'] == index && item['isLiked']);
                              mySavedList.toggleLike(
                                  index, !isLiked, assetImages[index]);
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
        }
    );
  }
}
