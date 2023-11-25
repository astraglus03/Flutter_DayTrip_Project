import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
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
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CircularIconButton(icon: Icons.camera),
                CircularIconButton(icon: Icons.album),
                CircularIconButton(icon: Icons.location_on),
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

  const CircularIconButton({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
