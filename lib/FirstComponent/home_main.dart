import 'package:final_project/FirstComponent/home_exhibition.dart';
import 'package:final_project/FirstComponent/home_popular.dart';
import 'package:final_project/FirstComponent/home_recent.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // 이 부분은 날짜 형식을 지역에 맞게 설정하기 위해 필요한 패키지입니다.

List<Map<String, dynamic>> db_exhibi_date = [];
List<Map<String, dynamic>> db_exhibi_name = [];
List<Map<String, dynamic>> db_exhibi_tag = [];
List<Map<String, dynamic>> db_image = [];
List<Map<String, dynamic>> db_locationName = [];
List<Map<String, dynamic>> db_spaceName = [];

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
        final locationString = document.data()!['location'];
        final name = document.data()!['name'];
        final spaceName = document.data()!['spaceName'];
        String locationName =
            document.data()!['locationName'] ?? ''; // 또는 다른 기본값 설정
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

  List<String> exhibitionImagePaths = [];
  List<ExhibitionPostInfo> exhibitionPostInfoList = [];

  // 각 이미지별 좋아요 상태를 저장하는 리스트
  List<bool> isLiked = List.generate(3, (index) => false);

  Future<void> toggleLike(String pid, bool isLiked) async {
    // Get the current user
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
                // Add user's uid to likes array if not already liked
                await postDocRef.update({
                  'likes': FieldValue.arrayUnion([uid]),
                });
                print("Liked post successfully");
              } else {
                // Remove user's uid from likes array if already liked
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
              // 3장까지만 가져오기
              postInfoList: recentPostInfoList,
              // Pass the list of RecentPostInfo objects
              onLikeButtonPressed: toggleLike, // Pass the toggleLike function
            ),
            SizedBox(height: 20),
            Title(
              title: "다가오는 전시 ∙ 행사 일정",
              showAll: true,
              onTap: () {
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
                print('Selected day: $day');
              },
            ),
            SizedBox(height: 20),
            if (selectedDay.isNotEmpty)
              SelectedDay(
                selectedDay: _selectedDay,
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
              imagePaths: [
                'asset/img/friend.jpg',
                'asset/img/friend2.jpg',
                'asset/img/friend3.jpg',
                // Add more image paths as needed
              ],
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
      List<RecentPostInfo> updatedRecentPostInfoList = [];

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

          if (writtenTime.isNotEmpty && _isToday(writtenTime)) {
            updatedRecentImagePaths.add(image);

            updatedRecentPostInfoList.add(RecentPostInfo(
              spaceName: spaceName,
              image: image,
              pid: pid,
              writtenTime: writtenTime,
            ));
          }
        }
      }

      setState(() {
        recentPostInfoList = updatedRecentPostInfoList;
        recentImagePaths = updatedRecentImagePaths;
      });
    } catch (e) {
      // Handle exceptions
      print('Error fetching data: $e');
      // You might want to show an error message to the user here
    }
  }

  bool _isToday(String writtenTime) {
    final now = DateTime.now();
    final parsedTime = DateFormat('yyyy/MM/dd - HH:mm:ss').parse(writtenTime);

    // Compare the year, month, and day of both dates
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
  bool isLiked;

  RecentPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.writtenTime,
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

  PopularPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.writtenTime,
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

class RecentPost extends StatefulWidget {
  final List<String> imagePaths;
  final List<RecentPostInfo> postInfoList; // List of RecentPostInfo objects
  final Function(String, bool)
      onLikeButtonPressed; // Function to handle like button press

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
              onTap: () {},
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
                            : Icons.favorite_border,
                        color:
                            Colors.red, // Keep default icon color if not liked
                      ),
                      onPressed: () {
                        // Toggle like status when the button is pressed
                        bool isCurrentlyLiked =
                            widget.postInfoList[index].isLiked;
                        String pid = widget.postInfoList[index].pid;

                        // Call the function to handle like button press
                        widget.onLikeButtonPressed(pid, !isCurrentlyLiked);

                        setState(() {
                          // Update the like status in the UI
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
      onTap: () => onSelected(day),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: isSelected ? Colors.blue : Colors.transparent,
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

  const SelectedDay({
    required this.selectedDay,
  });

  @override
  _SelectedDayState createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late String _selectedDay;
  late List<Widget> exhibitions; // 전시 정보를 담을 리스트

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
    _selectedDay = widget.selectedDay;
    exhibitions = [];
    _fetchExhibitionsForSelectedDay(_selectedDay);
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
      _fetchExhibitionsForSelectedDay(_selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: exhibitions.isEmpty
          ? Center(child: Text('정보가 없습니다.'))
          : ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: exhibitions.length,
        itemBuilder: (context, index) {
          return exhibitions[index];
        },
      ),
    );
  }

  void _fetchExhibitionsForSelectedDay(String selectedDay) {
    exhibitions.clear(); // 기존에 있던 전시 정보를 비워줍니다.

    for (int i = 0; i < db_exhibi_date.length; i++) {
      String exhibiDate = db_exhibi_date[i]['exhibi_date'];

      if (getDayFromDate(exhibiDate) == selectedDay) {
        String spaceName = db_spaceName[i]['spaceName'];
        String locationName = db_locationName[i]['locationName'];
        String image = db_image[i]['image'];
        String exhibiTag = db_exhibi_tag[i]['exhibi_tag'];
        String exhibiName = db_exhibi_name[i]['exhibi_name'];

        Widget exhibitionWidget = YourWidgetForExhibition(
          image,
          locationName,
          exhibiTag,
          exhibiName,
          exhibiDate,
        );

        setState(() {
          exhibitions.add(exhibitionWidget); // 선택된 요일과 매칭되는 경우에만 리스트에 추가합니다.
        });
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
      ) {
    return SizedBox(
      height: 120.0,
      child: Row(
        children: [
          Expanded(
            flex: 1,
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

  const PopularPost({required this.imagePaths});

  @override
  _PopularPostState createState() => _PopularPostState();
}

class _PopularPostState extends State<PopularPost> {
  List<bool> isLikedList = []; // Track liked status for each image

  @override
  void initState() {
    super.initState();
    // Initialize liked status for each image as false initially
    isLikedList =
        List<bool>.generate(widget.imagePaths.length, (index) => false);
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
              onTap: () {
                _updateAllLocations();
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(imagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        isLikedList[index]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isLikedList[index]
                            ? Colors.red
                            : Colors.red, // Change icon color
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle the liked status on button press
                          isLikedList[index] = !isLikedList[index];
                        });
                        // TODO: Define additional action when the like button is pressed
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
