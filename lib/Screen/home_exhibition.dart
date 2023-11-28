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
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now(); // 현재 날짜 저장

  // 날짜 선택했을 때, 전시 정보 띄우기
  String selectedDay = ''; // 선택된 요일 추적을 위한 변수
  int selectedDayIndex = 0; // 선택된 '일' 추적하기 위한 변수(25일, 13일 등)
  DateTime now = DateTime.now();

  // 수평 슬라이드 캘린더 선택 함수
  void onDaySelected1(int day) {
    setState(() {
      this.selectedDayIndex = day; // 선택된 요일 업데이트
    });
    //print('Selected day: $day');

  }

  // 메인 캘린더 함수
  void onDaySelected2(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate; // 선택한 날짜 업데이트

      selectedDay = DateFormat('d').format(selectedDate); // 선택된 날짜로 '일' 값을 문자열로 업데이트
      int dayNumber = int.parse(selectedDay); // '일' 값을 정수로 변환
      this.selectedDayIndex = dayNumber; // 선택한 날짜를 상태로 업데이트
      onDaySelected1(dayNumber); // 변경된 '일' 값을 전달해주기 위해 함수 호출
    });
    Navigator.pop(context); // Modal을 닫습니다.


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

                  selectedDayIndex = int.parse(selectedDay); // '일' 값을 정수로 변환
                  //onDaySelected1(selectedDayIndex); // 변환된 값을 전달
                });
                print('Selected day: ${selectedDayIndex}'); // 며칠 클릭하면, 그 숫자 출력
              },
            ),
            Text(
                "전시 ∙ 행사 일정은 주최측 사정에 따라 변경될 수 있습니다.",
                textAlign: TextAlign.start, // 왼쪽 정렬
                style: TextStyle(fontSize: 13, color: Colors.grey,),
            ),
            if (selectedDay.isNotEmpty) // 선택된 날짜에 맞게 정보 표시
              SelectedDay(selectedDayIndex: selectedDayIndex),
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
              onDaySelected: (date, focusedDate) {
                setState(() {
                  selectedDate = date;
                  selectedDay = DateFormat('d').format(date); // 선택된 날짜로 '일' 값을 문자열로 업데이트

                  selectedDayIndex = int.parse(selectedDay); // '일' 값을 정수로 변환 -> 전달 안 하면 동기화 안 됨!
                  //onDaySelected1(selectedDayIndex); // 변환된 값을 전달

                  Navigator.pop(context);
                });
                print('Selected day: ${selectedDayIndex}'); // 며칠 클릭하면, 그 숫자 출력
              },
              selectedDate: selectedDate,

              selectedIndex: selectedDayIndex, // 현재 선택된 날짜 인덱스 전달
            ),
          ),
        );
      },
    );
  }
}

// 달력 위젯
class MainCalendar extends StatefulWidget {
  final Function(DateTime, DateTime) onDaySelected;
  final DateTime selectedDate;

  final int selectedIndex;
  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,

    required this.selectedIndex,
  });

  @override
  _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  late DateTime focusedDay;
  DateTime selectedDate = DateTime.now(); // 선택한 날짜 상태
  int _selectedIndex=0;


  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            // 날짜를 표시하는 캘린더 위젯
            TableCalendar(
              locale: 'ko_kr',
              // 캘린더에서 날짜가 선택되었을 때
              onDaySelected: (date, focusedDate) {
                setState(() {
                  focusedDay = focusedDate; // 포커스된 날짜를 업데이트
                });
                widget.onDaySelected(date, focusedDate); // 선택된 날짜를 부모 위젯에 전달
              },

              selectedDayPredicate: (date) =>
              date.year == widget.selectedDate.year &&
                  date.month == widget.selectedDate.month &&
                  date.day == widget.selectedDate.day,
              focusedDay: focusedDay, // 캘린더에 표시할 포커스된 날짜 설정
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
  final Function(DateTime) onDaySelected; // 날짜 선택 시 호출할 함수
  final int selectedDayIndex;
  final DateTime selectedDate; // 선택한 날짜 상태

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
  late DateTime lastDayOfMonth = DateTime(now.year, now.month, -1); // 일 기준에 맞추기 위해
  late DateTime lastDayOfMonth2 = DateTime(now.year, now.month, 0); //요일 기준으로는 맞음. 하지만 '일' 기준으로는 다음 달 정보가 들어옴

  DateTime selectedDate = DateTime.now(); //
  DateTime currentDate = DateTime.now(); // 현재 날짜 저장

  // 여기서부터 _controller까지 선택된 날짜가 중앙에 자동으로 오게 설정하는 변수
  late double screenWidth;
  late double itemWidth;
  late double scrollPosition;

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    //lastDayOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1)); // 마지막 날짜 가져오기 위해

    _controller = ScrollController();

    // 초기 오늘 날짜가 자동으로 중앙에 오도록
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
      itemWidth = 58.0; // 각 항목의 너비 (날짜 항목의 너비)


      scrollPosition = (widget.selectedDate.day - 1) * itemWidth - screenWidth / 2 + itemWidth / 2;
      // 선택된 날짜의 인덱스에 따른 초기 스크롤 위치 계산
      _controller.jumpTo(scrollPosition); // 스크롤 위치로 이동

    });

  }

  @override
  void didUpdateWidget(DatePickerCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDayIndex != widget.selectedDayIndex) {
      _scrollToSelectedDate();
    }
  }

  void _scrollToSelectedDate() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 58.0;
    final newScrollPosition = (widget.selectedDayIndex - 1) * itemWidth - screenWidth / 2 + itemWidth / 2;

    _controller.animateTo(
      newScrollPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    //selectedIndex = widget.selectedDayIndex; // Add this line
    //selectedIndex = widget.selectedDayIndex; //widget.selectedDayIndex: 메인캘린더에서 선택 날짜 인덱스 / selectedIndex: 수평 캘린더 선택 인덱스 (동기화)
    print('selectedIndex: $selectedIndex');
    print('widget.selectedDayIndex: ${widget.selectedDayIndex}');
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤
        controller: _controller, // 추가된 ScrollController 사용
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: List.generate(
            lastDayOfMonth.day, // 개수
            (index) {

              final currentDate = lastDayOfMonth2.add(Duration(days: index + 1));
              final dayName = DateFormat('E', 'ko_KR').format(currentDate); // 예) 월, 화 등

              // 선택된 날짜에 대한 스타일을 변경하기 위한 부분 (메인 캘린더에서 선택했을 때도 연동됨)
              final isSelected = index == widget.selectedDayIndex-1 || (index == DateTime.now().day - 1 && widget.selectedDayIndex == 0);
                                          // 인덱스는 0부터 시작함         // 처음에는 무조건 오늘 날짜에 주황색 동그라미로 초기화하기 위해

              return Padding(
                padding:
                    EdgeInsets.only(left: index == 0 ? 16.0 : 0.0, right: 16.0),
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;

                    ///////////// 추가!
                    widget.onDaySelected(
                      lastDayOfMonth2.add(Duration(days: index + 1)), // 일 기준에 맞춘 변수 넣기. 요일 변수에 맞춘 lastDayOfMonth를 넣으면 인덱스가 1씩 밀림
                    );

                    ///////////////고쳐
                    // 선택된 날짜의 인덱스 -> 중앙 정렬하기 위해 업데이트
                    //if(index == selectedIndex){
                    print('Index: $index');
                    /*
                    double newScrollPosition = (lastDayOfMonth2.add(Duration(days: index + 1)).day - 1) * itemWidth - screenWidth / 2 + itemWidth / 2;
                    _controller.animateTo(
                      newScrollPosition,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                     */

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
                            color: isSelected ? Colors.black : Colors.black54,
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
                          color: isSelected ? Colors.orange : Colors.transparent,
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
  late int _selectedDayIndex; 

  // 날짜 선택할 때마다 다른 정보 나올 수 있게 업데이트 //init 메서드 쓰면 안 됨. 업데이트 안 되기 때문
  @override
  void didUpdateWidget(covariant SelectedDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedDayIndex = widget.selectedDayIndex;
  }

  @override
  Widget build(BuildContext context) {
    _selectedDayIndex = widget.selectedDayIndex; // 날짜 갱신
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
