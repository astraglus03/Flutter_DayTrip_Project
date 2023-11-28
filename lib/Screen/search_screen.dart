import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // CupertinoSearchTextField 사용을 위해 추가

class SearchScreen extends StatelessWidget {
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
        // 뒤로가기 버튼 비활성화
        leading: Container(),
        // AppBar에 CupertinoSearchTextField 직접 추가
        flexibleSpace: Container(
          padding: EdgeInsets.fromLTRB(16.0, 35.0, 40.0, 0.0),
          child: CupertinoSearchTextField(
            backgroundColor: Colors.black, // 원하는 배경색으로 설정
            onTap: () {

            },
            onChanged: (String value) {
              //
            },
            onSubmitted: (String value) {
              //
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CircularIconButton(icon: Icons.school, label: '학교'),
                CircularIconButton(icon: Icons.food_bank, label: '음식'),
                CircularIconButton(icon: Icons.cake, label: '케이크'),
                // 추가적인 아이콘들을 여기에 추가
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CircularIconButton({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: () {
              // 원형 버튼을 눌렀을 때 수행할 동작 추가
            },
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
