import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Screen/map_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 전체 항목과 검색 결과를 저장할 리스트
  List<Map<String, dynamic>> items = space;
  List<String> filteredItems = [];

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
            onTap: () {
            },
            onChanged: (String value) {
              // 검색어가 변경될 때마다 검색 결과 갱신
              setState(() {
                filteredItems = items
                    .where((item) =>
                    item['name'].toLowerCase().contains(value.toLowerCase()))
                    .map((item) => item['name'].toString()) // 'name' 필드만 가져와서 리스트로 변환
                    .toList();
              });
            },
            onSubmitted: (String value) {
              // 검색어 제출 시 수행할 동작 추가
              // 여기에 필요한 동작을 추가하세요.
            },
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
                return ListTile(
                  title: Text(filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
