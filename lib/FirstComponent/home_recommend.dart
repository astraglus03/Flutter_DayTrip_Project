import 'package:flutter/material.dart';
import 'home_recom_detail.dart';

class HomeRecommend extends StatefulWidget {
  const HomeRecommend({Key? key});

  @override
  _HomeRecommendState createState() => _HomeRecommendState();
}

class _HomeRecommendState extends State<HomeRecommend> {
  Map<String, List<String>> tagsToPlaces = {
    '운동': ['프라임홀', '학술정보관 열람실 2층'],
    '팀플': ['세미나실', '한누리관 7층'],
    // 다른 태그와 해당 장소들을 추가하세요.
  };

  List<String>? currentPlaces;
  String? selectedTag;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text('추천 장소를 태그를 클릭하여 확인하세요.'),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                _buildSearchButton('공부'),
                SizedBox(width: 10), // 간격 추가
                _buildSearchButton('팀플'),
                SizedBox(width: 10), // 간격 추가
                _buildSearchButton('운동'),
              ]),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                _buildSearchButton('산책'),
                SizedBox(width: 10), // 간격 추가
                _buildSearchButton('휴식'),
              ]),
          SizedBox(height: 20),
          Result(updatePlaces: updatePlaces, currentPlaces: currentPlaces, tag: selectedTag,),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchButton(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
            selectedTag = label; // 선택된 태그 업데이트
            updatePlaces(label);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updatePlaces(String tag) {
    setState(() {
      currentPlaces = tagsToPlaces[tag];
    });
  }
}

class Result extends StatelessWidget {
  final Function(String) updatePlaces;
  final List<String>? currentPlaces;
  final String? tag;

  Result({
    Key? key,
    required this.updatePlaces,
    required this.currentPlaces,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text('추천 장소>'),
          SizedBox(height: 10),
          if (currentPlaces != null)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: currentPlaces!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(currentPlaces![index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeRecomDetail(
                            placeName: currentPlaces![index],
                            tag: tag,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          else
            Container(),
        ],
      ),
    );
  }
}
