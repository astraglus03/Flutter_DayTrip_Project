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
  late LatLng currentLocation = LatLng(36.83407, 127.1793);
  late LatLng exampleLocation = LatLng(36.834, 127.179);
  Set<Marker> _markers = {};

  Future<LatLng?> _updateExampleLocation() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('space')
          .doc('starbucks')
          .get();

      final locationString = snapshot.data()!['location'];

      if (locationString != null) {
        final cleanString = locationString.replaceAll('LatLng(', '').replaceAll(')', '');
        final coordinates = cleanString.split(',');
        double latitude = double.parse(coordinates[0].trim());
        double longitude = double.parse(coordinates[1].trim());

        setState(() {
          exampleLocation = LatLng(latitude, longitude);
          print('예비 장소: $exampleLocation');
        });

        return exampleLocation;
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  Future<void> _updateAllLocations() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('space')
          .get();

      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        final locationString = document.data()!['location'];
        final name = document.data()!['name'];

        if (locationString != null) {
          final cleanString = locationString.replaceAll('LatLng(', '').replaceAll(')', '');
          final coordinates = cleanString.split(',');
          double latitude = double.parse(coordinates[0].trim());
          double longitude = double.parse(coordinates[1].trim());

          final LatLng placeLocation = LatLng(latitude, longitude);

          final Marker marker = Marker(
            markerId: MarkerId(placeLocation.toString()),
            position: placeLocation,
            infoWindow: InfoWindow(
              title: name,
              snippet: '여기에 있습니다.',
            ),
            onTap: () {
              _fetchFoodMarkerData(placeLocation);
            },
          );

          setState(() {
            _markers.add(marker);
          });
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _updateAllLocations().then((value) {
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
                FocusScope.of(context).requestFocus(FocusNode());
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
      _markers.add(marker);
    });

    mapController.animateCamera(
      CameraUpdate.newLatLng(currentLocation),
    );
  }

  void _foodmarker() async {
    final Marker marker = Marker(
      markerId: MarkerId(exampleLocation.toString()),
      position: exampleLocation,
      infoWindow: InfoWindow(
        title: '식당 위치',
        snippet: '여기에 있습니다.',
      ),
      onTap: () {
        _fetchFoodMarkerData(exampleLocation);
      },
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _fetchFoodMarkerData(LatLng location) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('space')
          .where('location', isEqualTo: 'LatLng(${location.latitude}, ${location.longitude})')
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
        String image = document.data()!['image'];
        String locationString = document.data()!['location'];
        String locationName = document.data()!['locationName'];
        String spaceName = document.data()!['spaceName'];
        String tag = document.data()!['tag'];

        _showFoodDialog(image, locationString, locationName, spaceName, tag);
      } else {
        print('No data found for the selected marker.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  void _showFoodDialog(String image, String locationString, String locationName, String spaceName, String tag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('음식점 정보'),
          content: Container(
            width: 300,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(image),
                SizedBox(height: 10),
                Text('위치: $locationString'),
                Text('장소 이름: $locationName'),
                Text('공간 이름: $spaceName'),
                Text('태그: $tag'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('관련 글 보기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(),
                  ),
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
}
