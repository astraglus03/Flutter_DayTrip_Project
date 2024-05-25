import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:final_project/Screen/map_screen.dart';

class HomeRecomDetail extends StatefulWidget {
  final String placeName;
  final String? tag;
  final String? originTag;
  final String? locationName;
  late String? imagePath;

  HomeRecomDetail({
    required this.placeName,
    required this.tag,
    this.originTag,
    this.locationName,
    this.imagePath,
  });

  @override
  _HomeRecomDetailState createState() => _HomeRecomDetailState();
}

class _HomeRecomDetailState extends State<HomeRecomDetail> {
  LatLng? convertedLocation;

  @override
  void initState() {
    super.initState();
    fetchLocationFromDatabase();
  }
  Future<void> fetchLocationFromDatabase() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('space')
          .where('locationName', isEqualTo: widget.locationName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? fetchedImagePath = querySnapshot.docs.first['image'];

        if (fetchedImagePath != null) {
          setState(() {
            widget.imagePath = fetchedImagePath;
          });
        }
        String? location = querySnapshot.docs.first['location'];
        // print('김건동: $location');

        LatLng? newLocation = getLatLngFromString(location);
        if (newLocation != null) {
          setState(() {
            convertedLocation = newLocation;
          });
          print("바뀐위치: $convertedLocation");
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  LatLng? getLatLngFromString(String? locationString) {
    if (locationString != null && locationString.contains(',')) {
      try {
        final cleanString = locationString.replaceAll('LatLng(', '').replaceAll(')', '');
        final coordinates = cleanString.split(',');
        double latitude = double.parse(coordinates[0].trim());
        double longitude = double.parse(coordinates[1].trim());

        final placeLocation = LatLng(latitude, longitude);
        final Marker marker = Marker(
          markerId: MarkerId(placeLocation.toString()),
          position: placeLocation,
          infoWindow: InfoWindow(
            title: '여기',
            snippet: '여기에 있습니다.',
          ),
        );

        return placeLocation;

      } catch (e) {
        print('Error parsing LatLng: $e');
        return null;
      }
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    print('현재 위치: ${convertedLocation}');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
                    child: Image.network(widget.imagePath!, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 6.0,
                    left: 16.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.placeName}\n\n',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            '${widget.locationName}\n',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            ' ${widget.originTag}',
                            style: TextStyle(fontSize: 18.0),
                          ),

                        ],
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
                child: convertedLocation != null
                    ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: convertedLocation!,
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(darkMapStyle);
                  },
                  markers: convertedLocation != null
                      ? Set<Marker>.of([
                    Marker(
                      markerId: MarkerId('마커'),
                      position: convertedLocation!,
                      infoWindow: InfoWindow(
                        title: '현재 위치',
                        snippet: '해당 위치 입니다.',
                      ),
                    ),
                  ])
                      : Set<Marker>(),
                )
                    : Center(child: CircularProgressIndicator()),
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

                    SizedBox(height: 10,),
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

                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Icon(Icons.location_on, size: 24.0, color: Colors.red), // 주소 아이콘
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '주소: ${widget.locationName}',
                            style: TextStyle(fontSize: 18.0),
                            maxLines: 3, // 최대 3줄까지 표시
                            overflow: TextOverflow.ellipsis, // overflow 시 생략 부호 표시
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Icon(Icons.tag, size: 24.0, color: Colors.green), // 태그 아이콘
                        SizedBox(width: 8.0),
                        Text(
                          '추천태그: ${widget.tag}',
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
