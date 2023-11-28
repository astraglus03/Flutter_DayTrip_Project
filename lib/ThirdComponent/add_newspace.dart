import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddNewSpace extends StatefulWidget {
  const AddNewSpace({super.key});

  @override
  State<AddNewSpace> createState() => _AddNewSpaceState();
}

class _AddNewSpaceState extends State<AddNewSpace> {

  late GoogleMapController mapController;
  File? selectedGalleryImage;
  String? hashTagButton;
  LatLng? newSpaceLocation;

  void _onMapTapped(LatLng location) {
    setState(() {
      newSpaceLocation = location; // 터치한 위치의 좌표를 저장
    });
  }

  // 해시태그 버튼
  void selectHashTagButton(String buttonText) {
    setState(() {
      if (hashTagButton == buttonText) {
        hashTagButton = ''; // 이미 선택된 버튼을 다시 누르면 선택 해제
      } else {
        hashTagButton = buttonText; // 새로운 버튼을 선택
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새로운 공간 추가 "),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _getImageFromGallery(); // 갤러리에서 이미지 가져오기
                  },
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: selectedGalleryImage != null
                        ? Image.file(selectedGalleryImage!, fit: BoxFit.cover)
                        : Center(child: Text("    사진을\n추가하세요.")),
                  ),
                ),
                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  height: 270,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    onTap: _onMapTapped,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(37.7749, -122.4194),
                      zoom: 15.0,
                    ),
                  ),
                ),

                SizedBox(height: 20,),


                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("위도: ${newSpaceLocation?.latitude ?? ''}"),
                        SizedBox(height: 5,),
                        Text("경도: ${newSpaceLocation?.longitude ?? ''}"),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '장소 이름을 입력하세요.',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),

                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton('카페'),
                      SizedBox(width: 10),
                      buildButton('음식점'),
                      SizedBox(width: 10),
                      buildButton('편의점'),
                      SizedBox(width: 10),
                      buildButton('학교건물'),
                      SizedBox(width: 10),
                      buildButton('주차장'),
                      SizedBox(width: 10),
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                InkWell(
                  onTap: () {

                    // Navigator.push(context, MaterialPageRoute(builder: (context) => UploadData()));
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        '데이로그 업로드',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        )
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedGalleryImage = File(pickedFile.path);
      });
    }
  }

  Widget buildButton(String buttonText) {
    return TextButton(
      onPressed: () {
        selectHashTagButton(buttonText);
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: hashTagButton == buttonText ? Colors.white : Colors.black,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: hashTagButton == buttonText
            ? MaterialStateProperty.all<Color>(Colors.blue) // 선택된 버튼의 배경색
            : MaterialStateProperty.all<Color>(Colors.transparent),
        side: MaterialStateProperty.all(BorderSide(
          color: Colors.black,
          width: 1.0,
        )),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
