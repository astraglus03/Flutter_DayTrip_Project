import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:final_project/Screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late LatLng currentLocation = LatLng(36.83407, 127.1793);//현재위치 저장
  late LatLng exampleLocation = LatLng(36.834, 127.179); //음식점 예시
  Set<Marker> _markers = {}; // 현재위치 마커
  Set<Marker> food_markers = {}; //음식점 마커


  Future<LatLng?> _updateExampleLocation() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('space')
          .doc('starbucks')
          .get();

      final locationString = snapshot.data()!['location']; // 'location' 필드의 문자열 값 가져오기

      // 위치 정보가 'LatLng(위도, 경도)' 형식의 문자열인 경우
      if (locationString != null) {
        // 'LatLng('와 ')'를 제거하여 순수한 숫자 문자열로 추출
        final cleanString = locationString.replaceAll('LatLng(', '').replaceAll(')', '');

        // 쉼표(,)를 기준으로 분할하여 위도와 경도 값 얻기
        final coordinates = cleanString.split(',');
        double latitude = double.parse(coordinates[0].trim());
        double longitude = double.parse(coordinates[1].trim());

        setState(() {
          exampleLocation = LatLng(latitude, longitude); // exampleLocation 업데이트
          print('예비 장소: $exampleLocation');
        });

        return exampleLocation; // LatLng 반환
      }
    } catch (e) {
      print('Error: $e');
    }

    return null; // 예외가 발생하거나 위치 정보가 없는 경우 null 반환
  }


  final darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _updateExampleLocation().then((value) {
      _foodmarker();
    });
    _getCurrentLocation();

  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });

              mapController.setMapStyle(darkMapStyle);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(36.83407, 127.1793),
              zoom: 16.0,
            ),
            markers: _markers,

          ),

          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: CupertinoSearchTextField(
              backgroundColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              onChanged: (String value) {},
              onSubmitted: (String value) {},
            ),
          ),

          Positioned(
            top: 85.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSearchButton('버튼1'),
                _buildSearchButton('버튼2'),
                _buildSearchButton('버튼3'),
                _buildSearchButton('버튼4'),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                      onTap: () {
                        // 리스트 아이템을 누를 때 새로운 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceBlogScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  _addMarker();
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black54,
                child: Icon(Icons.navigation_rounded),
              ),
            ),
          ),
        ],
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
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _addMarker() {
    final Marker marker = Marker(
      markerId: MarkerId(currentLocation.toString()),
      position: currentLocation,
      infoWindow: InfoWindow(
        title: '현재 위치',
        snippet: '여기에 있습니다.',
      ),
    );

    setState(() {
      //_markers.clear();
      _markers.add(marker);
    });

    mapController.animateCamera(
      CameraUpdate.newLatLng(currentLocation),
    );
  }
  void _foodmarker() async{
    // 커스텀 마커 바꾸기
    //BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
    //  ImageConfiguration(size: Size(48, 48)), // 사이즈 변경
    //  'asset/img/foodmarker.png', // Replace with your image file
    //);
    final Marker marker = Marker(
        markerId: MarkerId(exampleLocation.toString()),
        position: exampleLocation,
        // icon: customMarker,
        infoWindow: InfoWindow(
          title: '식당 위치',
          snippet: '여기에 있습니다.',
        ),
        onTap: (){
          _showFoodDialog();
        }
    );

    setState(() {
      //_markers.clear();
      _markers.add(marker);
    });
  }

  void _showFoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('음식점 정보'),
          content: Container(
            width: 300,
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'asset/img/school1.jpg',
                  width: 200,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text('음식점 설명 텍스트'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('관련 글 보기'), // 추가한 버튼
              onPressed: () {
                // 더보기 버튼이 눌렸을 때 수행할 동작 추가
                // 예: 다른 다이얼로그 띄우기, 추가 정보 표시 등
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(),
                  ), // 괄호를 닫아주어야 합니다.
                );
              },
            ),
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}