import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<Map<String, dynamic>> placesData = []; // placesData를 클래스 레벨 변수로 정의

  Future<void> fetchPlacesByTag(String tag) async {
    try {
      placesData.clear(); // 이전 데이터 지우기

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('post')
          .where('recomTag', isEqualTo: tag)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('spaceName')) {
          Map<String, dynamic> placeData = {
            'spaceName': data['spaceName'],
            'locationName': data['locationName'],
            'originTag': data['tag'],
            'imagePath': data['image'],
            'tag': data['recomTag'],
          };
          placesData.add(placeData);
        }
      });

      updatePlacesList(tag); // 데이터를 가져온 후 장소 목록 업데이트
    } catch (e) {
      print("장소 가져오기 오류: $e");
    }
  }

  void updatePlacesList(String tag) {
    setState(() {
      currentPlaces = placesData.map((data) => data['spaceName'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0), // Column 전체에 대한 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('추천 장소를 태그를 클릭하여 확인하세요.'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSearchButton('공부'),
                SizedBox(width: 10),
                _buildSearchButton('팀플'),
                SizedBox(width: 10),
                _buildSearchButton('운동'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSearchButton('산책'),
                SizedBox(width: 10),
                _buildSearchButton('휴식'),
              ],
            ),
            SizedBox(height: 20),
            Result(
              updatePlaces: updatePlaces,
              currentPlaces: currentPlaces,
              tag: selectedTag,
              placesData: placesData, // placesData를 Result 위젯에 전달
            ),
            SizedBox(height: 20),
          ],
        ),
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
          onTap: () async {
            selectedTag = label; // 선택된 태그 업데이트
            await fetchPlacesByTag(selectedTag!);

            List<String> places = placesData.map((data) => data['spaceName'] as String).toList();
            // Update places with spaceNames
            updatePlaces(label, places);
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

  void updatePlaces(String tag, List<String> places) {
    setState(() {
      currentPlaces = places;
    });
  }
}

class Result extends StatelessWidget {
  final Function(String, List<String>) updatePlaces;
  final List<String>? currentPlaces;
  final String? tag;
  final List<Map<String, dynamic>> placesData;

  Result({
    Key? key,
    required this.updatePlaces,
    required this.currentPlaces,
    this.tag,
    required this.placesData,
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
                String placeName = currentPlaces![index];
                print('추천태그:${placesData[index]['originTag']}');
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(placeName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeRecomDetail(
                            placeName: currentPlaces![index],
                            tag: tag!,
                            locationName: placesData[index]['locationName'],
                            originTag: placesData[index]['originTag'],
                            imagePath: placesData[index]['imagePath'],
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
