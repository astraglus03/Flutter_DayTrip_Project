import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model_db/space.dart';
import 'package:flutter/material.dart';

class ChooseSpace extends StatefulWidget {
  @override
  State<ChooseSpace> createState() => _ChooseSpaceState();
}

class _ChooseSpaceState extends State<ChooseSpace> {
  List<SpaceModel>? spaceModels;

  @override
  void initState() {
    super.initState();
    fetchSpaceModels(); // Firestore에서 SpaceModel 데이터 가져오기
  }

  Future<void> fetchSpaceModels() async {
    // Firestore에서 SpaceModel 객체들을 가져오는 비동기 메소드 호출
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('space').get();

    setState(() {
      // Firestore에서 가져온 데이터를 SpaceModel 객체로 변환하여 리스트에 저장
      spaceModels = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return SpaceModel(
          spaceName: data['spaceName'] ?? '',
          location: data['location'] ?? '',
          tag: data['tag'] ?? '',
          image: data['image'] ?? '',
          locationName: data['locationName'] ?? '',
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공간 추가'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            // 검색창
            Container(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  // 검색 기능 구현
                },
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),

            SizedBox(height: 10,),

            Expanded(
              child: spaceModels == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: spaceModels!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // 선택된 공간 정보 처리
                      SpaceModel selectedSpace = spaceModels![index];
                      Navigator.pop(context, selectedSpace); // 데이터 반환
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              spaceModels![index].image,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spaceModels![index].spaceName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  spaceModels![index].locationName,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
