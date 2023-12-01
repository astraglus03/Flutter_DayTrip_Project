import 'package:final_project/FourthComponent/save_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySavedList extends StatefulWidget {
  const MySavedList({Key? key});

  @override
  State<MySavedList> createState() => _MySavedListState();
}

class _MySavedListState extends State<MySavedList> {
  @override
  Widget build(BuildContext context) {
    SaveClass mySavedList = Provider.of<SaveClass>(context);

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
        mySavedList.savedItems.isEmpty
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
            : GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 줄에 표시할 아이템 수
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: mySavedList.savedItems.length,
          itemBuilder: (context, index) {
            final item = mySavedList.savedItems[index];
            final String imagePath = item['imagePath'];
            final bool isLiked = item['isLiked'];
            final String spaceName = item['spaceName'];

            return Stack(
              children: [
                SizedBox(
                  width: 133,
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            spaceName,
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
                  left: 80,
                  child: IconButton(
                    icon: isLiked
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        String recognizePid = item['pid'];
                        mySavedList.removeFromSavedList(recognizePid);
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
