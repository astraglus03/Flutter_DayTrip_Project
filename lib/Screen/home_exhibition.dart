import 'package:flutter/material.dart';
import 'package:final_project/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // DateFormat을 사용하기 위해 import
import 'package:intl/date_symbol_data_local.dart'; // 이거 써야 한국어 적용됨.

import 'package:horizontal_calendar/horizontal_calendar.dart';

class HomeExhibition extends StatefulWidget {
  const HomeExhibition({Key? key}) : super(key: key);

  @override
  _HomeExhibitionState createState() => _HomeExhibitionState();
}

class _HomeExhibitionState extends State<HomeExhibition> {
  DateTime selectedDate =
      DateTime.now(); // Add this line to store selected date
  DateTime currentDate = DateTime.now(); // 현재 날짜 저장

  // 날짜 선택했을 때, 전시 정보 띄우기
  String selectedDay = ''; // 선택된 요일 추적을 위한 변수
  int selectedDayIndex = 0; // 선택된 요일을 추적하기 위한 변수
  DateTime now = DateTime.now();

  void onDaySelected(int day) {
    setState(() {
      selectedDayIndex = day; // 선택된 요일 업데이트
    });
    //print('Selected day: $day');
  }

  @override
  void initState() {
    super.initState();
    // 로케일 데이터 초기화
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    //String formattedDate = DateFormat('yyyy년 MM월').format(currentDate);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: GestureDetector(
              onTap: () {
                _showCalendarModal(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('yyyy년 MM월').format(currentDate),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      )), // 현재 날짜 표시),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      // 버튼을 눌렀을 때 showModalBottomSheet 호출
                      _showCalendarModal(context);
                    },
                  ),
                ],
              ),
            )),
        body: Column(
          children: [
            DatePickerCustom(
              selectedDate: selectedDate, // 선택된 날짜 정보
              selectedDayIndex: selectedDayIndex,
              onDaySelected: (DateTime date) {
                setState(() {
                  selectedDate = date;
                  selectedDay = DateFormat('d').format(date); // 선택된 날짜로 '일' 값을 문자열로 업데이트

                  int dayNumber = int.parse(selectedDay); // '일' 값을 정수로 변환
                  onDaySelected(dayNumber); // 변환된 값을 전달
                });
                print('Selected day: ${DateFormat('d').format(date)}'); // 며칠 클릭하면, 그 숫자 출력
              },
            ),
            Text(
                "전시 ∙ 행사 일정은 주최측 사정에 따라 변경될 수 있습니다.",
                textAlign: TextAlign.start, // 왼쪽 정렬
                style: TextStyle(fontSize: 13, color: Colors.grey,),
            ),
            if (selectedDay.isNotEmpty) // 선택된 날짜에 맞게 정보 표시
              SelectedDay(selectedDayIndex: int.parse(selectedDay)),
          ],
        )
    );
  }

  // 달력 띄우기
  void _showCalendarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: MainCalendar(
              onDaySelected: (selectedDate, focusedDate) {
                setState(() {
                  this.now = selectedDate; // Update selected date
                });
                Navigator.pop(context);
              },
              selectedDate: now,
            ),
          ),
        );
      },
    );
  }
}

// 달력 위젯
class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TableCalendar(
              locale: 'ko_kr',
              // 한국어 설정
              onDaySelected: (date, focusedDate) {
                onDaySelected(date, focusedDate);
              },
              selectedDayPredicate: (date) =>
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day,
              focusedDay: DateTime.now(),
              firstDay: DateTime(1900, 1, 1),
              lastDay: DateTime(2200, 12, 31),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: LIGHT_GREY_COLOR,
                ),
                weekendDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: LIGHT_GREY_COLOR,
                ),
                selectedDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: PRIMARY_COLOR,
                    width: 1.0,
                  ),
                ),
                defaultTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: DARK_GREY_COLOR,
                ),
                weekendTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: DARK_GREY_COLOR,
                ),
                selectedTextStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// week단위 캘린더 (수평 방향 스크롤 위젯)
class DatePickerCustom extends StatefulWidget {
  final Function(DateTime) onDaySelected; // 함수
  final int selectedDayIndex;
  final DateTime selectedDate;

  const DatePickerCustom({
    Key? key,
    required this.onDaySelected,
    required this.selectedDayIndex,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<DatePickerCustom> createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {
  int selectedIndex = DateTime.now().day - 1; // 오늘 날짜가 기본으로 선택됨
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth = DateTime(now.year, now.month, 0); // month+1이면 다음 달 정보
  DateTime selectedDate = DateTime.now(); // Add this line to store selected date
  DateTime currentDate = DateTime.now(); // 현재 날짜 저장

  @override
  void initState() {
    super.initState();
    //lastDayOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1)); // 마지막 날짜 가져오기 위해
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: List.generate(
            lastDayOfMonth.day, // 개수
            (index) {
              final currentDate = lastDayOfMonth.add(Duration(days: index + 1));
              final dayName =
                  DateFormat('E', 'ko_KR').format(currentDate); // 예) 월, 화 등
              return Padding(
                padding:
                    EdgeInsets.only(left: index == 0 ? 16.0 : 0.0, right: 16.0),
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;

                    ///////////// 추가!
                    widget.onDaySelected(
                      lastDayOfMonth.add(Duration(days: index + 1)),
                    );

                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //요일
                      Container(
                        height: 42.0,
                        width: 42.0,
                        alignment: Alignment.center,
                        child: Text(
                          dayName.substring(0, 1),
                          style: TextStyle(
                            fontSize: 24.0,
                            color: selectedIndex == index
                                ? Colors.black
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // 며칠(숫자)
                      Container(
                        height: 42.0,
                        width: 42.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.orange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(44.0),
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // 오늘 날짜에 점 표시(동그라미 모양)
                      CircleAvatar(
                        radius: 4.0,
                        backgroundColor: index + 1 == DateTime.now().day
                            ? Colors.orange
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// 선택한 날짜마다 다른 전시&행사 정보
class SelectedDay extends StatefulWidget {
  final int selectedDayIndex;

  const SelectedDay({
    required this.selectedDayIndex,
  });

  @override
  _SelectedDayState createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late int _selectedDayIndex = 1; // 처음 날짜 1로 초기화. 0으로 하면 처음 1 인식 못함

  // 날짜 선택할 때마다 다른 정보 나올 수 있게 업데이트 //init 메서드 쓰면 안 됨. 업데이트 안 되기 때문
  @override
  void didUpdateWidget(covariant SelectedDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedDayIndex = widget.selectedDayIndex;
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedDayIndex) {
      case 1:
        // 일요일에 대한 정보
        return Column(
          children: [
            Row(
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
            ),
            SizedBox(height: 20.0,),
            Row(
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
            )
          ],
        );
      case 2:
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
