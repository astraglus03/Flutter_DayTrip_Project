import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:final_project/Screen/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceBlogScreen extends StatefulWidget {
  final String image;
  final String location;
  final String locationName;
  final String spaceName;
  final String tag;

  PlaceBlogScreen({
    required this.image,
    required this.location,
    required this.locationName,
    required this.spaceName,
    required this.tag
  });

  @override
  _PlaceBlogScreenState createState() => _PlaceBlogScreenState();
}

List<String> userImages = [];
List<String> userIDs = [];
List<String> userName = [];
List<String> contents = [];

class _PlaceBlogScreenState extends State<PlaceBlogScreen> {
  int selectedUserIndex = -1; // 선택된 사용자를 추적하기 위한 변수
  List<String> userPosts = [
    '사용자 1의 글입니다.',
    '사용자 2의 글입니다.',
    '사용자 3의 글입니다.',
    '사용자 4의 글입니다.',
  ];


  List<String> userImages = []; // 사용자 이미지 URL 목록

  Future<void> loadUserImages() async {
    userImages = await getUserImages(widget.spaceName);
    setState(() {}); // 이 부분을 추가하여 화면을 갱신합니다.

    print(userImages);
  }

  @override
  void initState() {
    super.initState();
    loadUserImages();
  }

  Future<List<String>> getUserImages(String spaceName) async {


    // 'users' 컬렉션에 대한 참조
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // 'users' 컬렉션의 모든 문서를 가져오기
    QuerySnapshot userQuerySnapshot = await users.get();

    // 'users' 컬렉션의 문서를 반복
    for (QueryDocumentSnapshot userDoc in userQuerySnapshot.docs) {
      // 'post' 컬렉션의 모든 문서를 가져오기
      QuerySnapshot postQuerySnapshot =
      await users.doc(userDoc.id).collection('post').get();

      // 'post' 컬렉션의 문서를 반복하고 'spaceName' 필드를 확인하여 필터링
      postQuerySnapshot.docs.forEach((postDoc) {
        if (postDoc['spaceName'] == spaceName) {
          // 'image'가 이미지 URL이 저장된 필드로 가정
          String image = userDoc['image'] ?? ''; // 'image' 필드가 없으면 빈 문자열로 대체
          String name = userDoc['displayName'];
          String content = postDoc['postContent'];

          userImages.add(image);
          userName.add(name);
          contents.add(content);
          userIDs.add(userDoc.id); // 해당 문서의 ID를 저장
        }
      });
    }

    print('User IDs: $userIDs');
    print('User Images: $userImages');
    print(contents);
    print(userName);

    return userImages;
  }


  @override
  Widget build(BuildContext context) {
    print('spaceName: ${widget.spaceName}');
    print('location: ${widget.location}');
    print('locationName: ${widget.locationName}');
    print('tag: ${widget.tag}');
    print('image: ${widget.image}');
    return WillPopScope(
        onWillPop: () async {
          userImages = [];
          userIDs = [];
          userName = [];
          contents = [];
          selectedUserIndex = -1;
          return true; // 뒤로 가기 허용
        },
        child: Scaffold(
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
                        child: Image.network(widget.image, fit: BoxFit.cover,),
                      ),
                      Positioned(
                        bottom: 6.0,
                        left: 16.0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '${widget.spaceName}\n\n${widget.locationName}\n\n${widget.tag}',
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
                                  userImages = [];
                                  userIDs = [];
                                  userName = [];
                                  contents = [];
                                  selectedUserIndex = -1;
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

                  SizedBox(height: 10,),

                  // 사용자 버튼들
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(userImages.length, (index) {
                      return InkWell(
                        onTap: () {
                          // 사용자 선택 시 처리
                          setState(() {
                            selectedUserIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedUserIndex == index ? Colors.white : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userImages[index]),
                            radius: 20.0,
                          ),
                        ),
                      );
                    }),
                  ),

                  // 선택된 사용자가 쓴 글 표시
                  // 선택된 사용자가 쓴 글 표시
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '선택된 사용자 글',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0), // 간격 추가
                        selectedUserIndex != -1
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '작성자: ${userName[selectedUserIndex]}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '작성 글: ${contents[selectedUserIndex]}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),

                  // 지도를 표시할 Container
                  Container(
                    height: 200,
                    child: GoogleMap(
                      // 초기 카메라 위치 설정
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse(widget.location.split('(')[1].split(',')[0].trim()), // 위도 추출
                          double.parse(widget.location.split(',')[1].split(')')[0].trim()), // 경도 추출
                        ),
                        zoom: 15.0,
                      ),
                      // 지도 스타일 적용
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(darkMapStyle);
                      },
                      // 마커 추가
                      markers: {
                        Marker(
                          markerId: MarkerId('locationMarker'),
                          position: LatLng(
                            double.parse(widget.location.split('(')[1].split(',')[0].trim()), // 위도 추출
                            double.parse(widget.location.split(',')[1].split(')')[0].trim()), // 경도 추출
                          ),
                          infoWindow: InfoWindow(
                            title: '${widget.spaceName}',
                            snippet: '${widget.tag}',
                          ),
                        ),
                      },
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
                              '장소 이름: ${widget.spaceName}',
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
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
        )
    );
  }
}