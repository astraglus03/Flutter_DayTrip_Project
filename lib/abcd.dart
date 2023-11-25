import 'package:flutter/material.dart';

class SpaceInfo {
  final String imagePath;
  final String title;
  final String location;

  SpaceInfo({
    required this.imagePath,
    required this.title,
    required this.location,
  });
}

class ChooseSpace extends StatelessWidget {
  final List<SpaceInfo> spaceInfoList = [
    // Your SpaceInfo list remains the same...
  ];

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
            SizedBox(height: 10),
            // Your existing search bar container...
            // ... (Your search bar widget remains the same)
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Show modal bottom sheet when the button is pressed

              },
              child: Text('Show Modal Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
