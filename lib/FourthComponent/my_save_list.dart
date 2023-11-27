import 'package:flutter/material.dart';

class MySavedList extends StatefulWidget {

   MySavedList({super.key});

  @override
  State<MySavedList> createState() => _MySavedListState();
}

class _MySavedListState extends State<MySavedList> {
  bool isLiked = false;
  final List<String> assetImages = [
    // 'asset/github.png',
    // 'asset/apple.jpg',
    // 'asset/apple.jpg',
  ];

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
                  // 클릭했을때 이벤트처리
                  onTap: (){},

                  child: Text("전체보기 >", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),),
                )
              ],
            ),
          ),
        ),

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
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: isLiked ? Icon(Icons.favorite, color: Colors.red,)
                        : Icon(Icons.favorite_border, color: Colors.red,),
                    onPressed: () {
                      // 좋아요 토글 기능 구현
                      setState(() {
                        isLiked = !isLiked;
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
}
