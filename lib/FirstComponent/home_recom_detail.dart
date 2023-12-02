import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:final_project/Screen/map_screen.dart';

class HomeRecomDetail extends StatefulWidget {
  final String placeName;
  final String? tag; // 추가된 부분

  const HomeRecomDetail({Key? key, required this.placeName, this.tag}) : super(key: key);

  @override
  _HomeRecomDetailState createState() => _HomeRecomDetailState();
}

class _HomeRecomDetailState extends State<HomeRecomDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    child: Image.asset('asset/img/school1.jpg', fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 6.0,
                    left: 16.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '${widget.placeName}.\n\n 천안, 안서동 . 공부',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      height: kToolbarHeight + MediaQuery.of(context).padding.top,
                      decoration: BoxDecoration(

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white,),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.home_outlined, color: Colors.white,),
                                onPressed: () {
                                  // 메뉴 버튼 동작
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz, color: Colors.white,),
                                onPressed: () {
                                  // 메뉴 버튼 동작
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // 지도를 표시하는 Container
              Container(
                height: 300,
                child: GoogleMap(
                  // 초기 위치 설정 (예: 서울)
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.5665, 126.9780),
                    zoom: 15.0,
                  ),
                  // 지도 스타일 적용
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(darkMapStyle);
                  },
                  // 추가 설정 및 마커 등을 여기에 추가 가능
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 장소 정보
                    Text(
                      '장소 정보',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.place, size: 24.0, color: Colors.blue), // 장소 아이콘
                        SizedBox(width: 8.0),
                        Text(
                          '장소 이름: ${widget.placeName}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 24.0, color: Colors.red), // 주소 아이콘
                        SizedBox(width: 8.0),
                        Text(
                          '주소: 천안, 안서동',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.tag, size: 24.0, color: Colors.green), // 태그 아이콘
                        SizedBox(width: 8.0),
                        Text(
                          '태그: ${widget.tag}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
