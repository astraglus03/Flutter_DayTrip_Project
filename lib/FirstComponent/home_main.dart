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
  List<String> popularImagePaths = [];
  List<PopularPostInfo> popularPostInfoList = [];


  List<String> exhibitionImagePaths = [];
  List<ExhibitionPostInfo> exhibitionPostInfoList = [];



  // 각 이미지별 좋아요 상태를 저장하는 리스트
  List<bool> isLiked = List.generate(3, (index) => false);

  Future<void> toggleLike(String pid, bool isLiked) async {
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
              imagePaths: recentImagePaths.take(3).toList(), // 3장까지만 가져오기
              postInfoList: recentPostInfoList,
              onLikeButtonPressed: toggleLike,
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
              selectedDay: selectedDay,
              imagePaths: exhibitionImagePaths,
              exhibitionPostInfoList: exhibitionPostInfoList,
              onDaySelected: (String day) {
                setState(() {
                  selectedDay = day;
                });
                onDaySelected(day);
                print('Selected day: $day');
              },
            ),

            SizedBox(height: 20),
            if (selectedDay.isNotEmpty)
              SelectedDay(
                selectedDay: selectedDay,
                imagePaths: exhibitionImagePaths,
                exhibitionPostInfoList: exhibitionPostInfoList,
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
              onLikeButtonPressed: toggleLike,
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
    fetchExhibitionPostModel();
  }

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
          String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
          String image = data.containsKey('image') ? data['image'] : '';
          String pid = data.containsKey('pid') ? data['pid'] : '';
          String writtenTime = data.containsKey('writtenTime') ? data['writtenTime'] : '';
          String tag = data.containsKey('tag') ? data['tag']: '';
          String locationName = data.containsKey('locationName') ? data['locationName']: '';

          if (writtenTime.isNotEmpty && _isToday(writtenTime)) {
            updatedRecentImagePaths.add(image);

            updatedRecentPostInfoList.add(RecentPostInfo(
              spaceName: spaceName,
              image: image,
              pid: pid,
              writtenTime: writtenTime,
              tag : tag,
              locationName: locationName,
            ));
          }

          if (writtenTime.isNotEmpty && _isToday(writtenTime)) {
            updatedPopularImagePaths.add(image);

            updatedPopularPostInfoList.add(PopularPostInfo(
              spaceName: spaceName,
              image: image,
              pid: pid,
              writtenTime: writtenTime,
              tag : tag,
              locationName: locationName,
            ));
          }
        }
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

    // Compare the year, month, and day of both dates
    return now.year == parsedTime.year &&
        now.month == parsedTime.month &&
        now.day == parsedTime.day;
  }

  Future<void> fetchExhibitionPostModel() async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');

      List<String> updatedExhibitionImagePaths = [];
      List<ExhibitionPostInfo> updatedExhibitionPostInfoList = [];


      final querySnapshot = await usersCollectionRef.get();
      for (final userDoc in querySnapshot.docs) {
        final postCollectionRef = userDoc.reference.collection('space');

        final postQuerySnapshot = await postCollectionRef.get();
        for (final postDoc in postQuerySnapshot.docs) {
          final data = postDoc.data();
          String spaceName = data.containsKey('spaceName') ? data['spaceName'] : '';
          String image = data.containsKey('image') ? data['image'] : '';
          String locationName = data.containsKey('locationName') ? data['locationName'] : '';
          String exhibi_tag = data.containsKey('exhibi_tag') ? data['exhibi_tag'] : '';
          String exhibi_name = data.containsKey('exhibi_name') ? data['exhibi_name'] : '';
          String exhibi_date = data.containsKey('exhibi_date') ? data['exhibi_date'] : '';

          updatedExhibitionImagePaths.add(image);

          updatedExhibitionPostInfoList.add(ExhibitionPostInfo(
            spaceName: spaceName,
            image: image,
            locationName : locationName,
            exhibi_tag: exhibi_tag,
            exhibi_name: exhibi_name,
            exhibi_date: exhibi_date,
          ));
        }
      }

      setState(() {
        exhibitionPostInfoList = updatedExhibitionPostInfoList;
        exhibitionImagePaths = updatedExhibitionImagePaths;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

// 최신 피드 db
class RecentPostInfo{
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
class ExhibitionPostInfo{
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
class PopularPostInfo{
  final String spaceName;
  final String image;
  final String pid;
  final String writtenTime;
  final String tag;
  final String locationName;
  bool isLiked;

  PopularPostInfo({
    required this.spaceName,
    required this.image,
    required this.pid,
    required this.writtenTime,
    required this.tag,
    required this.locationName,
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

                // Assume location and locationName are in the space collection
                QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
                    .collectionGroup('space') // 전체에서 space 컬렉션을 탐색
                    .where('locationName', isEqualTo: widget.postInfoList[index].locationName)
                    .get();

                // Check if the query has any results
                if (spaceSnapshot.docs.isNotEmpty) {
                  // Get the first document (assuming unique locationName values)
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
  final List<String> imagePaths;

  List<ExhibitionPostInfo> exhibitionPostInfoList = []; // exhibitionPostInfoList 정의

  ExhibitionSchedule({
    required this.selectedDay,
    required this.onDaySelected,
    required this.imagePaths,
    required this.exhibitionPostInfoList,
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
  List<String> imagePaths = []; // imagePaths 정의
  final List<ExhibitionPostInfo> exhibitionPostInfoList; // 추가된 부분

  SelectedDay({
    required this.selectedDay,
    required this.exhibitionPostInfoList, // 추가된 부분
    required this.imagePaths,
  });

  @override
  _SelectedDayState createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late String _selectedDay;
  late ExhibitionPostInfo _selectedPostInfo; // 추가된 부분

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    _selectedPostInfo = _getSelectedPostInfo(widget.selectedDay); // 추가된 부분
  }

  @override
  Widget build(BuildContext context) {
    _selectedPostInfo = _getSelectedPostInfo(_selectedDay); // 선택된 요일에 해당하는 정보 가져오기

    // 선택된 요일에 따라 다른 정보를 반환합니다.
    return _buildExhibitionInfo(_selectedPostInfo);
  }

  Widget _buildExhibitionInfo(ExhibitionPostInfo postInfo) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Image.network(
            _selectedPostInfo.image,
            width: 50,
            height: 120,
            fit: BoxFit.cover,
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
                  postInfo.exhibi_tag,
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
                SizedBox(height: 8),
                Text(
                  postInfo.exhibi_name,
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(height: 5),
                Text(
                  postInfo.locationName,
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
                        postInfo.exhibi_date,
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
  }


  // 선택된 요일에 해당하는 전시 정보를 반환하는 함수
  ExhibitionPostInfo _getSelectedPostInfo(String day) {
    return widget.exhibitionPostInfoList.firstWhere(
          (info) {
        if (info.exhibi_date.isNotEmpty) {
          DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(info.exhibi_date);
          String dayOfWeek = getDayOfWeekFromDate(parsedDate);
          return dayOfWeek == day;
        }
        return false; // exhibi_date가 비어있는 경우 false 반환
      },
      orElse: () => ExhibitionPostInfo(
        spaceName: '',
        image: '',
        locationName: '',
        exhibi_tag: '',
        exhibi_name: '',
        exhibi_date: '',
      ),
    );
  }

  String getDayOfWeekFromDate(DateTime date) {
    List<String> days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[date.weekday - 1];
  }



/*
// Define a function to get the day of the week from a date
  String getDayOfWeekFromDate(String dateStr) {
    final date = DateTime.parse(dateStr.replaceAll('년 ', '-').replaceAll('월 ', '-').replaceAll('일', ''));
    List<String> days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[date.weekday - 1];
  }

 */
}


// 인기 게시물
class PopularPost extends StatefulWidget {
  final List<String> imagePaths;
  final List<PopularPostInfo> postInfoList; // List of RecentPostInfo objects
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