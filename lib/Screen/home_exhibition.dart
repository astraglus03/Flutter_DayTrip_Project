import 'package:flutter/material.dart';

class HomeExhibition extends StatefulWidget {
  const HomeExhibition({Key? key}) : super(key: key);

  @override
  _HomeExhibitionState createState() => _HomeExhibitionState();

}

class _HomeExhibitionState extends State<HomeExhibition> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('2023년 11월'),
            IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {
                // 버튼을 눌렀을 때 showModalBottomSheet 호출
                _showCalendarModal(context);
              },
            ),
          ],
        ),
      ),
      //body: PostTab(), // DayLog 위젯을 여기에 추가
    );
  }
}

void _showCalendarModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Center(
          child: Text('Your Calendar Widget'),
        ),
      );
    },
  );
}
