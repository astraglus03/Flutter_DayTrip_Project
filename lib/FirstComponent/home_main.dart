import 'package:final_project/FirstComponent/home_exhibition.dart';
import 'package:final_project/FirstComponent/home_popular.dart';
import 'package:final_project/FirstComponent/home_recent.dart';
import 'package:final_project/Screen/place_blog_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key});

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  String selectedDay = ''; // 선택된 요일 추적을 위한 변수
  int selectedDayIndex = -1; // 선택된 요일을 추적하기 위한 변수

  List<String> recentImagePaths = [];
  List<RecentPostInfo> recentPostInfoList = [];

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
          final usersCollectionRef = FirebaseFirestore.instance.collection('users');
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
            //ImageSlider(),
            //SizedBox(height: 20),
            RecentPost(
              imagePaths: recentImagePaths.take(3).toList(), // 3장까지만 가져오기
              postInfoList: recentPostInfoList, // Pass the list of RecentPostInfo objects
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
            if (selectedDay.isNotEmpty) // 선택된 요일에 맞게 정보 표시
              SelectedDay(selectedDay: selectedDay),

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
    // Handle the selected date here
    print('Selected date from calendar: $selectedDate');
  }

  void onDateSelectedFromCustom(DateTime selectedDate) {
    // Handle the selected date here
    print('Selected date from custom: $selectedDate');
  }

  @override // SaveClass 인스턴스 초기화
  void initState() {
    super.initState();
    fetchRecentPostModel();
  }

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
          String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
          String image = data.containsKey('image') ? data['image'] : '';
          String pid = data.containsKey('pid') ? data['pid'] : '';
          String writtenTime = data.containsKey('writtenTime') ? data['writtenTime'] : '';

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

class RecentPostInfo{
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
  final Function(String, bool) onLikeButtonPressed; // Function to handle like button press

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
              onTap: () {
                // Navigate to PlaceBlogScreen when the image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(),
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
                            : Icons.favorite_border, color: Colors.red,// Keep default icon color if not liked
                      ),
                      onPressed: () {
                        // Toggle like status when the button is pressed
                        bool isCurrentlyLiked = widget.postInfoList[index].isLiked;
                        String pid = widget.postInfoList[index].pid;

                        // Call the function to handle like button press
                        widget.onLikeButtonPressed(pid, !isCurrentlyLiked);

                        setState(() {
                          // Update the like status in the UI
                          widget.postInfoList[index].isLiked = !isCurrentlyLiked;
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

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    _selectedDay =
        widget.selectedDay; // build 메서드에서도 선택된 요일 값을 업데이트(이 코드 안 쓰면 갱신 안 됨)
    switch (_selectedDay) {
      case '일':
      // 일요일에 대한 정보
        return Row(
          children: [
            Expanded(
              flex: 1, // Row의 1/4 영역 차지
              child: Image.asset(
                'asset/img/company1.jpg',
                width: 50,
                height: 120,
                fit: BoxFit.cover,
              ), // 일요일 이미지
            ),
            Expanded(
              flex: 3, // Row의 3/4 영역 차지
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                // 수평 방향(좌우로) 여백
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '전시', //
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '한국의 기하학적 추상미술',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '경기도',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.zero, // 좌측 여백 조절
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 오버플로우 방지
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero, // 아이콘 버튼 주변의 패딩 제거
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {},
                          ),
                          SizedBox(width: 1), // 아이콘과 텍스트 사이의 간격
                          Text(
                            '2023년 11월 16일 ~ 2024년 5월 19일',
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
        );
      case '월':
      // 월요일에 대한 정보
        return Row(
          children: [
            Expanded(
              flex: 1, // Row의 1/4 영역 차지
              child: Image.asset(
                'asset/img/company2.jpg',
                width: 50,
                height: 120,
                fit: BoxFit.cover,
              ), // 일요일 이미지
            ),
            Expanded(
              flex: 3, // Row의 3/4 영역 차지
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                // 수평 방향(좌우로) 여백
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '팝업', //
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '신세계백화점 본점 크리스마스 마켓',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '서울',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.zero, // 좌측 여백 조절
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 오버플로우 방지
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero, // 아이콘 버튼 주변의 패딩 제거
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {},
                          ),
                          SizedBox(width: 1), // 아이콘과 텍스트 사이의 간격
                          Text(
                            '2023년 11월 9일 ~ 2023년 12월 27일',
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
        );
    // 기본적으로 해당 요일에 정보가 없으면 빈 공간 반환
      default:
        return SizedBox(); // 선택된 요일이 없으면 빈 공간 반환
    }
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
              onTap: () {
                // Navigate to PlaceBlogScreen when the image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceBlogScreen(),
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
                        image: AssetImage(imagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        isLikedList[index] ? Icons.favorite : Icons.favorite_border,
                        color: isLikedList[index] ? Colors.red : Colors.red, // Change icon color
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