import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Screen/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 전체 항목과 검색 결과를 저장할 리스트
  List<Map<String, dynamic>> items = space;
  List<String> filteredItems = [];

  //spaceDB 필드값 저장
  late String DBimage = '';
  late String DBlocation = '';
  late String DBlocationName = '';
  late String DBspaceName = '';
  late String DBtag = '';

  @override
  void initState() {
    super.initState();

    // initState에서 filteredItems를 items로 초기화
    filteredItems = items.map((item) => item['name'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        leading: Container(),
        flexibleSpace: Container(
          padding: EdgeInsets.fromLTRB(16.0, 35.0, 40.0, 0.0),
          child: CupertinoSearchTextField(
            backgroundColor: Colors.black,
            onTap: () {},
            onChanged: (String value) {
              // 검색어가 변경될 때마다 검색 결과 갱신
              setState(() {
                filteredItems = items
                    .where((item) =>
                    item['name'].toLowerCase().contains(value.toLowerCase()))
                    .map((item) => item['name'].toString())
                    .toList();
              });
            },
            onSubmitted: (String value) {},
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          // 검색 결과를 표시할 리스트
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 검색 결과를 탭했을 때 처리하는 함수 호출
                    _handleSearchResultTap(filteredItems[index]);
                  },
                  child: ListTile(
                    title: Text(filteredItems[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 검색 결과를 탭할 때 처리할 함수
  void _handleSearchResultTap(String selectedItem) async {

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> userDocument in snapshot.docs) {
        QuerySnapshot<Map<String, dynamic>> spaceSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDocument.id)
            .collection('space')
            .where('spaceName', isEqualTo: selectedItem)
            .get();

        if (spaceSnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> document = spaceSnapshot.docs.first;

          String image = document.data()!['image'];
          String locationString = document.data()!['location'];
          String locationName = document.data()!['locationName'];
          String spaceName = document.data()!['spaceName'];
          String tag = document.data()!['tag'];

          //DB 불러온 값 변수에 저장
          DBimage = image;
          DBlocation = locationString;
          DBlocationName = locationName;
          DBspaceName = spaceName;
          DBtag = tag;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceBlogScreen(
                image: DBimage,
                location: DBlocation,
                locationName: DBlocationName,
                spaceName: DBspaceName,
                tag: DBtag,
              ),
            ),
          );

          return;
        }
      }

      print('선택한 마커에 대한 데이터를 찾을 수 없습니다.');
    } catch (e) {
      print('데이터를 가져오는 중 오류 발생: $e');
    }
  }
}


