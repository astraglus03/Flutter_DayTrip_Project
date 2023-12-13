import 'package:final_project/FirstComponent/home_exhibition.dart';
import 'package:final_project/FirstComponent/home_popular.dart';
import 'package:final_project/FirstComponent/home_recent.dart';
import 'package:final_project/Screen/exhibi_blog_screen.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // 이 부분은 날짜 형식을 지역에 맞게 설정하기 위해 필요한 패키지입니다.

List<Map<String, dynamic>> db_exhibi_date = [];
List<Map<String, dynamic>> db_exhibi_location = [];
List<Map<String, dynamic>> db_exhibi_name = [];
List<Map<String, dynamic>> db_exhibi_tag = [];
List<Map<String, dynamic>> db_image = [];
List<Map<String, dynamic>> db_locationName = [];
List<Map<String, dynamic>> db_spaceName = [];

late String ex_DATE = '';

//spaceDB 필드값 저장
late String DBexhibidate = '';
late String DBexhibiname = '';
late String DBexhibitag = '';
late String DBimage = '';
late String DBlocationName = '';
late String DBspaceName = '';
late String DBtag = '';

// 전시 db
Future<void> _updateAllLocations() async {
  try {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
    await FirebaseFirestore.instance.collection('users').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> userDocument
    in usersSnapshot.docs) {
      // 각 사용자 문서의 ID
      String userId = userDocument.id;

      // "space" 컬렉션에 대한 쿼리 수행
      QuerySnapshot<Map<String, dynamic>> spaceSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('space')
          .get();

      // "space" 컬렉션의 각 문서에 대한 작업 수행
      spaceSnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        // final locationString = document.data()!['location'];
        // final name = document.data()!['name'];
        final spaceName = document.data()!['spaceName'];
        String locationName =
            document.data()!['locationName'] ?? ''; // 또는 다른 기본값 설정
        String location =
            document.data()!['location'] ?? ''; // 또는 다른 기본값 설정
        String image = document.data()!['image'] ?? ''; // 또는 다른 기본값 설정
        String exhibi_date =
            document.data()!['exhibi_date'] ?? ''; // 또는 다른 기본값 설정
        String exhibi_tag =
            document.data()!['exhibi_tag'] ?? ''; // 또는 다른 기본값 설정
        String exhibi_name =
            document.data()!['exhibi_name'] ?? ''; // 또는 다른 기본값 설정
        String tag = document.data()!['tag'] ?? ''; // 또는 다른 기본값 설정

        if (exhibi_date.isNotEmpty && tag == '문화') {
          db_spaceName.add({'spaceName': spaceName});
          db_locationName.add({'locationName': locationName});
          db_image.add({'image': image});
          db_exhibi_date.add({'exhibi_date': exhibi_date});
          db_exhibi_location.add({'location': location});
          db_exhibi_tag.add({'exhibi_tag': exhibi_tag});
          db_exhibi_name.add({'exhibi_name': exhibi_name});
        }
      });
    }

    print(db_spaceName);
    print(db_locationName);
    print(db_image);
    print(db_exhibi_tag);
    print(db_exhibi_name);
    print(db_exhibi_date);
  } catch (e) {
    print('에러: $e');
  }
}

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key});

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  String selectedDay = ''; // 선택된 요일 추적을 위한 변수
  String _selectedDay = ''; // 선택된 요일
  int selectedDayIndex = -1; // 선택된 요일을 추적하기 위한 변수

  List<String> recentImagePaths = [];
  List<RecentPostInfo> recentPostInfoList = [];
  List<String> popularImagePaths = [];
  List<PopularPostInfo> popularPostInfoList = [];


  List<String> exhibitionImagePaths = [];
  List<ExhibitionPostInfo> exhibitionPostInfoList = [];

  // 각 이미지별 좋아요 상태를 저장하는 리스트
  List<bool> isLiked = List.generate(3, (index) => false);

  Future<void> toggleLike1(String pid, bool isLiked) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      int index = recentPostInfoList.indexWhere((post) => post.pid == pid);
      if (index != -1) {
        try {
          final usersCollectionRef =
          FirebaseFirestore.instance.collection('users');
          final querySnapshot = await usersCollectionRef.get();

          for (final userDoc in querySnapshot.docs) {
            final postCollectionRef = userDoc.reference.collection('post');
            final postDoc = await postCollectionRef.doc(pid).get();

            if (postDoc.exists) {
              DocumentReference postDocRef = postDoc.reference;

              if (isLiked) {
                await postDocRef.update({
                  'likes': FieldValue.arrayUnion([uid]),
                });
                print("Liked post successfully");
              } else {
                await postDocRef.update({
                  'likes': FieldValue.arrayRemove([uid]),
                });
                print("Unliked post successfully");
              }
            }
          }
        } catch (error) {
          print('Error toggling like: $error');
        }
      }
    }
  }

  Future<void> toggleLike2(String pid, bool isLiked) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      int index = popularPostInfoList.indexWhere((post) => post.pid == pid);
      if (index != -1) {
        try {
          final usersCollectionRef =
          FirebaseFirestore.instance.collection('users');
          final querySnapshot = await usersCollectionRef.get();

          for (final userDoc in querySnapshot.docs) {
            final postCollectionRef = userDoc.reference.collection('post');
            final postDoc = await postCollectionRef.doc(pid).get();

            if (postDoc.exists) {
              DocumentReference postDocRef = postDoc.reference;

              if (isLiked) {
                await postDocRef.update({
                  'likes': FieldValue.arrayUnion([uid]),
                });
                print("Liked post successfully");
              } else {
                await postDocRef.update({
                  'likes': FieldValue.arrayRemove([uid]),
                });
                print("Unliked post successfully");
              }
            }
          }
        } catch (error) {
          print('Error toggling like: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Title(
              title: "최신 피드",
              showAll: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeRecent()),
                );
              },
            ),
            SizedBox(height: 10),
            RecentPost(
              imagePaths: recentImagePaths.take(3).toList(),
              postInfoList: recentPostInfoList,
              onLikeButtonPressed: toggleLike1,
            ),
            SizedBox(height: 20),
            Title(
              title: "다가오는 전시 ∙ 행사 일정",
              showAll: true,
              onTap: () {
                exhibitions_1=[];exhibitions_2=[];exhibitions_3=[];
                exhibitions_4=[];exhibitions_5=[];exhibitions_6=[];
                exhibitions_7=[];exhibitions_8=[];exhibitions_9=[];
                exhibitions_10=[];exhibitions_11=[];exhibitions_12=[];
                exhibitions_13=[];exhibitions_14=[];exhibitions_15=[];
                exhibitions_16=[];exhibitions_17=[];exhibitions_18=[];
                exhibitions_19=[];exhibitions_20=[];exhibitions_21=[];
                exhibitions_22=[];exhibitions_23=[];exhibitions_24=[];
                exhibitions_25=[];exhibitions_26=[];exhibitions_27=[];
                exhibitions_28=[];exhibitions_29=[];exhibitions_30=[];
                exhibitions_31=[];
                db_exhibi_date = [];
                db_exhibi_name = [];
                db_exhibi_tag = [];
                db_image = [];
                db_locationName = [];
                db_spaceName = [];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeExhibition(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ExhibitionSchedule(
              selectedDay: selectedDay, // 선택된 요일 정보 전달
              onDaySelected: (String day) {
                setState(() {
                  selectedDay = day; // 선택된 요일 업데이트
                });
                onDaySelected(day); // 변환된 값을 전달
                print('ExhibitionSchedule의 선택 요일: $day');
              },
            ),
            SizedBox(height: 20),
            if (selectedDay.isNotEmpty)
              SelectedDay(
                selectedDay: selectedDay,
                onDaySelected: (String day) {
                  setState(() {
                    selectedDay = day; // 선택된 요일 업데이트
                  });
                  onDaySelected(day); // 변환된 값을 전달
                  print('Selected day의 선택 요일: $day');
                },
              ),
            SizedBox(height: 20),
            Title(
              title: "인기 피드",
              showAll: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePopular()),
                );
              },
            ),
            SizedBox(height: 10),
            PopularPost(
              imagePaths: popularImagePaths.take(3).toList(), // 3장까지만 가져오기
              postInfoList: popularPostInfoList,
              onLikeButtonPressed: toggleLike2,
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(String day) {
    setState(() {
      selectedDay = day; // 선택된 요일 업데이트
    });
    print('Selected day: $day');
  }

  void onDateSelectedFromCalendar(DateTime selectedDate) {
    print('Selected date from calendar: $selectedDate');
  }

  void onDateSelectedFromCustom(DateTime selectedDate) {
    print('Selected date from custom: $selectedDate');
  }

  @override
  void initState() {
    db_exhibi_date = [];
    db_exhibi_name = [];
    db_exhibi_tag = [];
    db_image = [];
    db_locationName = [];
    db_spaceName = [];
    super.initState();
    fetchRecentPostModel();
    //fetchExhibitionPostModel();
    _updateAllLocations();
  }

  // 최신 피드 db
  Future<void> fetchRecentPostModel() async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');

      List<String> updatedRecentImagePaths = [];
      List<String> updatedPopularImagePaths = [];
      List<RecentPostInfo> updatedRecentPostInfoList = [];
      List<PopularPostInfo> updatedPopularPostInfoList = [];

      final querySnapshot = await usersCollectionRef.get();
      for (final userDoc in querySnapshot.docs) {
        final postCollectionRef = userDoc.reference.collection('post');

        final postQuerySnapshot = await postCollectionRef.get();
        for (final postDoc in postQuerySnapshot.docs) {
          final data = postDoc.data();
          String spaceName =
          data.containsKey('spaceName') ? data['spaceName'] : '';
          String image = data.containsKey('image') ? data['image'] : '';
          String pid = data.containsKey('pid') ? data['pid'] : '';
          String writtenTime =
          data.containsKey('writtenTime') ? data['writtenTime'] : '';
          String tag = data.containsKey('tag') ? data['tag'] : '';
          String locationName =
          data.containsKey('locationName') ? data['locationName'] : '';

          if (writtenTime.isNotEmpty && _isToday(writtenTime)) {
            updatedRecentImagePaths.add(image);

            updatedRecentPostInfoList.add(RecentPostInfo(
              spaceName: spaceName,
              image: image,
              pid: pid,
              writtenTime: writtenTime,
              tag: tag,
              locationName: locationName,
            ));
          }

          // if (writtenTime.isNotEmpty) {
          //   updatedPopularImagePaths.add(image);
          //
          //   updatedPopularPostInfoList.add(PopularPostInfo(
          //     spaceName: spaceName,
          //     image: image,
          //     pid: pid,
          //     writtenTime: writtenTime,
          //     tag: tag,
          //     locationName: locationName,
          //   ));
          // }
        }
      }

      final postsCollectionRef = FirebaseFirestore.instance.collectionGroup('post');
      final popularPostsQuerySnapshot = await postsCollectionRef
          .orderBy('likes', descending: true)
          .limit(3)
          .get();

      for (final popularPostDoc in popularPostsQuerySnapshot.docs) {
        final data = popularPostDoc.data();
        String spaceName =
        data.containsKey('spaceName') ? data['spaceName'] : '';
        String image = data.containsKey('image') ? data['image'] : '';
        String pid = data.containsKey('pid') ? data['pid'] : '';
        String writtenTime =
        data.containsKey('writtenTime') ? data['writtenTime'] : '';
        String tag = data.containsKey('tag') ? data['tag'] : '';
        String locationName =
        data.containsKey('locationName') ? data['locationName'] : '';

        int likesCount = 0;
        if (data.containsKey('likes')) {
          if (data['likes'] is List) {
            likesCount = data['likes'].length;
          }
        }

        updatedPopularImagePaths.add(image);

        updatedPopularPostInfoList.add(PopularPostInfo(
          spaceName: spaceName,
          image: image,
          pid: pid,
          writtenTime: writtenTime,
          tag: tag,
          locationName: locationName,
          likesCount:likesCount,
        ));
      }

      setState(() {
        recentPostInfoList = updatedRecentPostInfoList;
        recentImagePaths = updatedRecentImagePaths;
        popularPostInfoList = updatedPopularPostInfoList;
        popularImagePaths = updatedPopularImagePaths;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  bool _isToday(String writtenTime) {
    final now = DateTime.now();
    final parsedTime = DateFormat('yyyy/MM/dd - HH:mm:ss').parse(writtenTime);

    return now.year == parsedTime.year &&
        now.month == parsedTime.month &&
        now.day == parsedTime.day;
  }
}

// 최신 피드 db
class RecentPostInfo {
  final String spaceName;
  final String image;
  final String pid;
  final String writtenTime;
  final String tag;
  final String locationName;
  bool isLiked;

  RecentPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.writtenTime,
    required this.tag,
    required this.locationName,
    this.isLiked = false,
  });
}


// 전시 행사 db
class ExhibitionPostInfo {
  final String spaceName;
  final String image;
  final String locationName;
  final String exhibi_tag;
  final String exhibi_name;
  final String exhibi_date;

  ExhibitionPostInfo({
    required this.spaceName,
    required this.image,
    required this.locationName,
    required this.exhibi_tag,
    required this.exhibi_name,
    required this.exhibi_date,
  });
}

// 인기 피드 db
class PopularPostInfo {
  final String spaceName;
  final String image;
  final String pid;
  final String writtenTime;
  final String tag;
  final String locationName;
  int? likesCount;
  bool isLiked;

  PopularPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.writtenTime,
    required this.tag,
    required this.locationName,
    this.likesCount,
    this.isLiked = false,
  });
}
// 최신 피드 / 전체 보기> 버튼
class Title extends StatelessWidget {
  final String title;
  final bool showAll; // 전체보기 클릭했는지 안 했는지
  final VoidCallback onTap;

  const Title(
      {required this.title, required this.showAll, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        if (showAll)
          GestureDetector(
            onTap: onTap,
            child: Text(
              "전체보기>",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }
}
// 최신 피드
class RecentPost extends StatefulWidget {
  final List<String> imagePaths;
  final List<RecentPostInfo> postInfoList;
  final Function(String, bool) onLikeButtonPressed;


  const RecentPost({
    required this.imagePaths,
    required this.postInfoList,
    required this.onLikeButtonPressed,
  });

  @override
  _RecentPostState createState() => _RecentPostState();
}

class _RecentPostState extends State<RecentPost> {
  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty || widget.postInfoList.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Text('최신 게시물이 없습니다.'),
        ),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
      items: widget.imagePaths.asMap().entries.map((entry) {
        final index = entry.key;
        final imagePath = entry.value;

        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                String location = '';

                QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
                    .collectionGroup('space') // 전체에서 space 컬렉션을 탐색
                    .where('locationName', isEqualTo: widget.postInfoList[index].locationName)
                    .get();

                if (spaceSnapshot.docs.isNotEmpty) {
                  location = spaceSnapshot.docs.first.get('location');
                }

                print('포스트인포:${widget.postInfoList[0].locationName}');
                print('포스트인포:${widget.postInfoList[1].locationName}');
                print('포스트인포:${widget.postInfoList[2].locationName}');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(
                      image: widget.postInfoList[index].image,
                      location: location,
                      locationName: widget.postInfoList[index].locationName,
                      spaceName: widget.postInfoList[index].spaceName,
                      tag: widget.postInfoList[index].tag,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        widget.postInfoList[index].isLiked
                            ? Icons.favorite
                            : Icons.favorite_border, color: Colors.red,
                      ),
                      onPressed: () {
                        bool isCurrentlyLiked =
                            widget.postInfoList[index].isLiked;
                        String pid = widget.postInfoList[index].pid;

                        widget.onLikeButtonPressed(pid, !isCurrentlyLiked);

                        setState(() {
                          widget.postInfoList[index].isLiked =
                          !isCurrentlyLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
// 전시, 행사 일정
class ExhibitionSchedule extends StatelessWidget {
  final List<String> days = ["일", "월", "화", "수", "목", "금", "토"];
  final String selectedDay;
  final void Function(String) onDaySelected; // 함수

  ExhibitionSchedule({
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var day in days)
          DayButton(
            day: day,
            isSelected: selectedDay == day,
            onSelected: (day) {
              onDaySelected(day);
            },
          ),
      ],
    );
  }
}


// 일요일~토요일 버튼 선택 표시
class DayButton extends StatelessWidget {
  final String day;
  final bool isSelected;
  final void Function(String) onSelected;

  DayButton({
    required this.day,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(day), // 선택된 요일을 onSelected 콜백으로 전달
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: isSelected ? Colors.orange : Colors.transparent,
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}


class SelectedDay extends StatefulWidget {
  final String selectedDay;
  final void Function(String) onDaySelected; // 추가된 부분

  const SelectedDay({
    required this.selectedDay,
    required this.onDaySelected, // 추가된 부분
  });

  @override
  _SelectedDayState createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late String _selectedDay;
  late List<Widget> exhibitions; // 전시 정보를 담을 리스트
  late List<Widget> exhibitions_sun;
  late List<Widget> exhibitions_mon;
  late List<Widget> exhibitions_tue;
  late List<Widget> exhibitions_wed;
  late List<Widget> exhibitions_thu;
  late List<Widget> exhibitions_fri;
  late List<Widget> exhibitions_sat;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
    _selectedDay = widget.selectedDay;
    exhibitions = [];
    exhibitions_sun = [];
    exhibitions_mon = [];
    exhibitions_tue = [];
    exhibitions_wed = [];
    exhibitions_thu = [];
    exhibitions_fri = [];
    exhibitions_sat = [];

    //_fetchExhibitionsForSelectedDay();
  }

  @override
  void didUpdateWidget(covariant SelectedDay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDay != widget.selectedDay) {
      updateSelectedDay(widget.selectedDay);
    }
  }

  // 추가된 메서드
  void updateSelectedDay(String day) {
    setState(() {
      _selectedDay = day;
      exhibitions.clear(); // 기존 전시 정보를 비웁니다.
      _fetchExhibitionsForSelectedDay();
    });
  }

  @override
  Widget build(BuildContext context) {

    print('빌드에서 선택 요일: ');
    print(_selectedDay);
    List<Widget> selectedList;

    // 요일에 따라 선택된 리스트 할당
    if (_selectedDay == '월') {
      selectedList = exhibitions_mon;
    } else if (_selectedDay == '화') {
      selectedList = exhibitions_tue;
    } else if (_selectedDay == '수') {
      selectedList = exhibitions_wed;
    }else if (_selectedDay == '목') {
      selectedList = exhibitions_thu;
    }else if (_selectedDay == '금') {
      selectedList = exhibitions_fri;
    }else if (_selectedDay == '토') {
      selectedList = exhibitions_sat;
    }else if (_selectedDay == '일') {
      selectedList = exhibitions_sun;
    }
    else {
      selectedList = []; // 기본적으로 빈 리스트로 설정
    }

    return GestureDetector(
      onTap: () {
        print('전시를 탭했습니다: $ex_DATE');
        print('sdfsdfsdfs $exhibitions_mon');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeRecent()),
        );
      },
      child: Container(
        height: 240,
        child: selectedList.isEmpty
            ? Center(child: Text('정보가 없습니다.'))
            : SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedList.length,
                itemBuilder: (context, index) {
                  return selectedList[index];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchExhibitionsForSelectedDay() {
    exhibitions_mon.clear(); // 이거 안 쓰면 요일 버튼 누를 때마다 전시 정보 누적해서 저장함
    exhibitions_tue.clear();
    exhibitions_wed.clear();
    exhibitions_thu.clear();
    exhibitions_fri.clear();
    exhibitions_sat.clear();
    exhibitions_sun.clear();

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // 이번 주의 시작
    DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday)); // 이번 주의 끝

    for (int i = 0; i < db_exhibi_date.length; i++) {
      String exhibiDate = db_exhibi_date[i]['exhibi_date'];
      print(getDayFromDate(exhibiDate));

      DateTime parsedExhibiDate = DateFormat('yyyy년 MM월 dd일').parse(exhibiDate, true);

      String spaceName = db_spaceName[i]['spaceName'];
      String locationName = db_locationName[i]['locationName'];
      String image = db_image[i]['image'];
      String exhibiTag = db_exhibi_tag[i]['exhibi_tag'];
      String exhibiName = db_exhibi_name[i]['exhibi_name'];
      String exhibiloation = db_exhibi_location[i]['location'];

      Widget exhibitionWidget = YourWidgetForExhibition(
        image,
        locationName,
        exhibiTag,
        exhibiName,
        exhibiDate,
        exhibiloation,
        onTap: () {
          // onTap 이벤트 처리
          print('전시물이 탭되었습니다!');
          print(image);
          print(exhibiloation);
          print(locationName);
          print(exhibiName);
          print(exhibiTag);
          print(exhibiDate);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExhibiBlogScreen(
                image: image,
                exhibiloation: exhibiloation,
                locationName: locationName,
                exhibiName: exhibiName,
                exhibiTag: exhibiTag,
              ),
            ),
          );

        },
      );

      if (parsedExhibiDate.isAfter(startOfWeek) && parsedExhibiDate.isBefore(endOfWeek)) {
        if(getDayFromDate(exhibiDate) == '월' && _selectedDay == '월'){
          setState(() {
            exhibitions_mon.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
          });
        }
        else if(getDayFromDate(exhibiDate) == '화' && _selectedDay == '화'){
          setState(() {
            exhibitions_tue.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가

          });
        }else if(getDayFromDate(exhibiDate) == '수'&& _selectedDay == '수'){
          setState(() {
            exhibitions_wed.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
            ex_DATE = exhibiName;
          });
        }else if(getDayFromDate(exhibiDate) == '목'&& _selectedDay == '목'){
          setState(() {
            exhibitions_thu.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
          });
        }else if(getDayFromDate(exhibiDate) == '금'){
          setState(() {
            exhibitions_fri.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
          });
        }else if(getDayFromDate(exhibiDate) == '토'){
          setState(() {
            exhibitions_sat.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
          });
        }else if(getDayFromDate(exhibiDate) == '일'){
          setState(() {
            exhibitions_sun.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가
          });
        }
      }
      }

  }

  // 실제 위젯에 넣는 부분
  Widget YourWidgetForExhibition(
      String image,
      String locationName,
      String exhibi_tag,
      String exhibi_name,
      String exhibi_date,
      String exhibilocation,{
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 120.0,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 120.0,
                  width: 50.0,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(image),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exhibi_tag,
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    SizedBox(),
                    Text(
                      exhibi_name,
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Text(
                      locationName,
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {},
                          ),
                          SizedBox(width: 1),
                          Text(
                            exhibi_date,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String getDayFromDate(String date) {
    var formatter = DateFormat('E', 'ko_KR'); // 요일을 축약된 형태로 표시하는 DateFormat 객체 생성
    DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(date);
    String day = formatter.format(parsedDate);
    print('파싱된 날짜: $parsedDate, 요일: $day');
    return day;
  }
}

// 인기 게시물
class PopularPost extends StatefulWidget {
  final List<String> imagePaths;
  final List<PopularPostInfo> postInfoList;
  final Function(String, bool) onLikeButtonPressed;

  const PopularPost({
    required this.imagePaths,
    required this.postInfoList,
    required this.onLikeButtonPressed,
  });

  @override
  _PopularPostState createState() => _PopularPostState();
}

class _PopularPostState extends State<PopularPost> {
  List<bool> isLikedList = [];

  @override
  void initState() {
    super.initState();
    isLikedList = List<bool>.generate(widget.imagePaths.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
      items: widget.imagePaths.asMap().entries.map((entry) {
        final index = entry.key;
        final imagePath = entry.value;

        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                String location = '';

                QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
                    .collectionGroup('space') // 전체에서 space 컬렉션을 탐색
                    .where('locationName', isEqualTo: widget.postInfoList[index].locationName)
                    .get();

                if (spaceSnapshot.docs.isNotEmpty) {
                  location = spaceSnapshot.docs.first.get('location');
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(
                      image: widget.postInfoList[index].image,
                      location: location,
                      locationName: widget.postInfoList[index].locationName,
                      spaceName: widget.postInfoList[index].spaceName,
                      tag: widget.postInfoList[index].tag,
                    ),
                  ),
                );

              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        widget.postInfoList[index].isLiked
                            ? Icons.favorite
                            : Icons.favorite_border, color: Colors.red,
                      ),
                      onPressed: () {
                        bool isCurrentlyLiked = widget.postInfoList[index].isLiked;
                        String pid = widget.postInfoList[index].pid;
                        widget.onLikeButtonPressed(pid, !isCurrentlyLiked);

                        setState(() {
                          if (widget.postInfoList[index].likesCount != null) {
                            if (isCurrentlyLiked) {
                              widget.postInfoList[index].likesCount = widget.postInfoList[index].likesCount! - 1;
                            } else {
                              widget.postInfoList[index].likesCount = widget.postInfoList[index].likesCount! + 1;
                            }
                          }
                          widget.postInfoList[index].isLiked = !isCurrentlyLiked;
                        });
                      },
                    ),
                  ),

                  Positioned(
                    top: 40,
                    right: 20,
                    child: Text("+${widget.postInfoList[index].likesCount}", style: TextStyle(
                      color: Colors.red,
                    ),),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}