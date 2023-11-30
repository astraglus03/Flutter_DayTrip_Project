import 'package:final_project/FirstComponent/home_exhibition.dart';
import 'package:final_project/FirstComponent/home_popular.dart';
import 'package:final_project/FirstComponent/home_recent.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen> {
    String selectedDay = ''; // 선택된 요일 추적을 위한 변수
    int selectedDayIndex = -1; // 선택된 요일을 추적하기 위한 변수
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


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          // 추가 부분
          title: Text('추천',
              style: TextStyle(color:Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
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
                  imagePaths: [
                    'asset/img/school1.jpg',
                    'asset/img/school2.jpg',
                    'asset/img/school3.jpg',
                    // Add more image paths as needed
                  ],
                ),

                SizedBox(height: 20),
                Title(
                  title: "다가오는 전시 ∙ 행사 일정",
                  showAll: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeExhibition(),
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
        ),
      );
    }
  }

// 최신 피드 / 전체 보기> 버튼
class Title extends StatelessWidget {
  final String title;
  final bool showAll; // 전체보기 클릭했는지 안 했는지
  final VoidCallback onTap;

  const Title({required this.title, required this.showAll, required this.onTap});

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

// 최신 피드 : 카루셀 Carousel (이미지 슬라이드)
class RecentPost extends StatelessWidget {
  final List<String> imagePaths;

  const RecentPost({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
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
    _selectedDay = widget.selectedDay; // build 메서드에서도 선택된 요일 값을 업데이트(이 코드 안 쓰면 갱신 안 됨)
    switch (_selectedDay) {
      case '일':
      // 일요일에 대한 정보
        return Row(
          children: [
            Expanded(
              flex: 1, // Row의 1/4 영역 차지
              child: Image.asset('asset/img/company1.jpg',
                      width: 50,
                      height: 120,
                      fit: BoxFit.cover,), // 일요일 이미지
            ),
            Expanded(
              flex: 3, // Row의 3/4 영역 차지
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // 수평 방향(좌우로) 여백
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
              child: Image.asset('asset/img/company2.jpg',
                width: 50,
                height: 120,
                fit: BoxFit.cover,), // 일요일 이미지
            ),
            Expanded(
              flex: 3, // Row의 3/4 영역 차지
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // 수평 방향(좌우로) 여백
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
class PopularPost extends StatelessWidget {
  final List<String> imagePaths;

  const PopularPost({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}