import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_project/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // DateFormat을 사용하기 위해 import
import 'package:intl/date_symbol_data_local.dart';
import '../Screen/exhibi_blog_screen.dart'; // 이거 써야 한국어 적용됨.

List<Map<String, dynamic>> db_exhibi_date = [];
List<Map<String, dynamic>> db_exhibi_name = [];
List<Map<String, dynamic>> db_exhibi_tag = [];
List<Map<String, dynamic>> db_image = [];
List<Map<String, dynamic>> db_locationName = [];
List<Map<String, dynamic>> db_spaceName = [];
List<Map<String, dynamic>> db_exhibi_location = [];

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
        final spaceName = document.data()!['spaceName'];
        String locationName =
            document.data()!['locationName'] ?? '';
        String location =
            document.data()!['location'] ?? '';
        String image = document.data()!['image'] ?? '';
        String exhibi_date =
            document.data()!['exhibi_date'] ?? '';
        String exhibi_tag =
            document.data()!['exhibi_tag'] ?? '';
        String exhibi_name =
            document.data()!['exhibi_name'] ?? '';
        String tag = document.data()!['tag'] ?? '';

        if (exhibi_date.isNotEmpty && tag == '문화') {
          db_spaceName.add({'spaceName': spaceName});
          db_locationName.add({'locationName': locationName});
          db_exhibi_location.add({'location': location});
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

late List<Widget> exhibitions_1;late List<Widget> exhibitions_2;
late List<Widget> exhibitions_3;late List<Widget> exhibitions_4;
late List<Widget> exhibitions_5;late List<Widget> exhibitions_6;
late List<Widget> exhibitions_7;late List<Widget> exhibitions_8;
late List<Widget> exhibitions_9;late List<Widget> exhibitions_10;
late List<Widget> exhibitions_11;late List<Widget> exhibitions_12;
late List<Widget> exhibitions_13;late List<Widget> exhibitions_14;
late List<Widget> exhibitions_15;late List<Widget> exhibitions_16;
late List<Widget> exhibitions_17;late List<Widget> exhibitions_18;
late List<Widget> exhibitions_19;late List<Widget> exhibitions_20;
late List<Widget> exhibitions_21;late List<Widget> exhibitions_22;
late List<Widget> exhibitions_23;late List<Widget> exhibitions_24;
late List<Widget> exhibitions_25;late List<Widget> exhibitions_26;
late List<Widget> exhibitions_27;late List<Widget> exhibitions_28;
late List<Widget> exhibitions_29;late List<Widget> exhibitions_30;
late List<Widget> exhibitions_31;

// 실제 위젯에 넣는 부분
Widget WidgetExhibition(
    String image,
    String locationName,
    String exhibi_tag,
    String exhibi_name,
    String exhibi_date,
    String exhibiloation,{
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

// 일 필터링
String getDayFromDate(String date) {
  var formatter = DateFormat('d');
  DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(date);
  String day = formatter.format(parsedDate);
  print('파싱된 날짜: $parsedDate, 요일: $day');
  return day;
}
// 월 필터링
String getMonthFromDate(String date) {
  var formatter = DateFormat('M');
  DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(date);
  String month = formatter.format(parsedDate);
  print('파싱된 월: $parsedDate, 월: $month');
  return month;
}
// 년도 필터링
String getYearFromDate(String date) {
  var formatter = DateFormat('yyyy');
  DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(date);
  String year = formatter.format(parsedDate);
  print('파싱된 날짜: $parsedDate, 요일: $year');
  return year;
}

// 전시 전체보기
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

  @override
  Widget build(BuildContext context) {
    //String formattedDate = DateFormat('yyyy년 MM월').format(currentDate);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
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
                print('초기화');
                print(exhibitions_4);
                Navigator.of(context).pop();
              },
            ),
            title: GestureDetector(
              onTap: () {
                _showCalendarModal(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('yyyy년 MM월').format(selectedDate),
                      textAlign: TextAlign.center),
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
                print('datepickercustom에서 출력: ${selectedDayIndex}'); // 며칠 클릭하면, 그 숫자 출력
                exhibitions_1.clear();exhibitions_2.clear();exhibitions_3.clear();
                exhibitions_4.clear();exhibitions_5.clear();exhibitions_6.clear();
                exhibitions_7.clear();exhibitions_8.clear();exhibitions_9.clear();
                exhibitions_10.clear();exhibitions_11.clear();exhibitions_12.clear();
                exhibitions_13.clear();exhibitions_14.clear();exhibitions_15.clear();
                exhibitions_16.clear();exhibitions_17.clear();exhibitions_18.clear();
                exhibitions_19.clear();exhibitions_20.clear();exhibitions_21.clear();
                exhibitions_22.clear();exhibitions_23.clear();exhibitions_24.clear();
                exhibitions_25.clear();exhibitions_26.clear();exhibitions_27.clear();
                exhibitions_28.clear();exhibitions_29.clear();exhibitions_30.clear();
                exhibitions_31.clear();
              },
            ),
            Text(
              "전시 ∙ 행사 일정은 주최측 사정에 따라 변경될 수 있습니다.",
              textAlign: TextAlign.start, // 왼쪽 정렬
              style: TextStyle(fontSize: 13, color: Colors.grey,),
            ),
            if (selectedDay.isNotEmpty) // 선택된 날짜에 맞게 정보 표시
              SelectedDay(selectedDayIndex: selectedDayIndex,
                  selectedDate: selectedDate),
          ],
        )
    );
  }

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
    _updateAllLocations();
  }

  // 달력 띄우기
  void _showCalendarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: MainCalendar(
              onDaySelected: (date, focusedDate) {
                setState(() {
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
  late DateTime lastDayOfMonth; // 일 기준에 맞추기 위해
  late DateTime lastDayOfMonth2; //요일 기준으로는 맞음. 하지만 '일' 기준으로는 다음 달 정보가 들어옴

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
    lastDayOfMonth = DateTime(now.year, now.month+1, 0);
    lastDayOfMonth2 = DateTime(now.year, now.month, 0);
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
    lastDayOfMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month+1, 0); // 일 기준에 맞추기 위해
    lastDayOfMonth2 = DateTime(widget.selectedDate.year, widget.selectedDate.month, 0);

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
                    // 선택된 날짜의 인덱스 -> 중앙 정렬하기 위해 업데이트
                    //if(index == selectedIndex){
                    print('Index: $index');
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
                            color: isSelected ? Colors.white : Colors.white54,
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
                            color: Colors.white,
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
  final DateTime selectedDate;

  const SelectedDay({required this.selectedDayIndex, required this.selectedDate,});

  @override
  _SelectedDayState createState() => _SelectedDayState();
}

class _SelectedDayState extends State<SelectedDay> {
  late int _selectedDayIndex;
  late DateTime _selectedDate = widget.selectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
    _selectedDayIndex = widget.selectedDayIndex;
    _selectedDate = widget.selectedDate;
    exhibitions_1=[];exhibitions_2=[];
    exhibitions_3=[];exhibitions_4=[];
    exhibitions_5=[];exhibitions_6=[];
    exhibitions_7=[];exhibitions_8=[];
    exhibitions_9=[];exhibitions_10=[];
    exhibitions_11=[];exhibitions_12=[];
    exhibitions_13=[];exhibitions_15=[];
    exhibitions_16=[];exhibitions_17=[];
    exhibitions_18=[];exhibitions_19=[];
    exhibitions_20=[];exhibitions_21=[];
    exhibitions_22=[];exhibitions_23=[];
    exhibitions_24=[];exhibitions_25=[];
    exhibitions_26=[];exhibitions_27=[];
    exhibitions_28=[];exhibitions_29=[];
    exhibitions_30=[];exhibitions_31=[];

    _fetchExhibitionsForSelectedDay();
  }

  // 날짜 선택할 때마다 다른 정보 나올 수 있게 업데이트 //init 메서드 쓰면 안 됨. 업데이트 안 되기 때문
  @override
  void didUpdateWidget(covariant SelectedDay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate != widget.selectedDate && oldWidget.selectedDayIndex != widget.selectedDayIndex) {
      updateSelectedDay(widget.selectedDate, widget.selectedDayIndex);
      //_fetchExhibitionsForSelectedDay();
    }
  }

  void updateSelectedDay(DateTime date, int day) {
    setState(() {
      _selectedDayIndex = day;
      _selectedDate = date;

      _fetchExhibitionsForSelectedDay();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('빌드에서 선택 며칠: ');
    print(_selectedDayIndex);
    List<Widget> selectedList;

    // 요일에 따라 선택된 리스트 할당
    if (_selectedDayIndex.toString() == '1') {
      selectedList = exhibitions_1;
    } else if (_selectedDayIndex.toString() == '2') {
      selectedList = exhibitions_2;
    } else if (_selectedDayIndex.toString() == '3') {
      selectedList = exhibitions_3;
    }else if (_selectedDayIndex.toString() == '4') {
      selectedList = exhibitions_4;
    }else if (_selectedDayIndex.toString() == '5') {
      selectedList = exhibitions_5;
    }else if (_selectedDayIndex.toString() == '6') {
      selectedList = exhibitions_6;
    }else if (_selectedDayIndex.toString() == '7') {
      selectedList = exhibitions_7;
    }else if (_selectedDayIndex.toString() == '8') {
      selectedList = exhibitions_8;
    }else if (_selectedDayIndex.toString() == '9') {
      selectedList = exhibitions_9;
    }else if (_selectedDayIndex.toString() == '10') {
      selectedList = exhibitions_10;
    }else if (_selectedDayIndex.toString() == '11') {
      selectedList = exhibitions_11;
    }else if (_selectedDayIndex.toString() == '12') {
      selectedList = exhibitions_12;
    }else if (_selectedDayIndex.toString() == '13') {
      selectedList = exhibitions_13;
    }else if (_selectedDayIndex.toString() == '14') {
      selectedList = exhibitions_14;
    }else if (_selectedDayIndex.toString() == '15') {
      selectedList = exhibitions_15;
    }else if (_selectedDayIndex.toString() == '16') {
      selectedList = exhibitions_16;
    }else if (_selectedDayIndex.toString() == '17') {
      selectedList = exhibitions_17;
    }else if (_selectedDayIndex.toString() == '18') {
      selectedList = exhibitions_18;
    }else if (_selectedDayIndex.toString() == '19') {
      selectedList = exhibitions_19;
    }else if (_selectedDayIndex.toString() == '20') {
      selectedList = exhibitions_20;
    }else if (_selectedDayIndex.toString() == '21') {
      selectedList = exhibitions_21;
    }else if (_selectedDayIndex.toString() == '22') {
      selectedList = exhibitions_22;
    }else if (_selectedDayIndex.toString() == '23') {
      selectedList = exhibitions_23;
    }else if (_selectedDayIndex.toString() == '24') {
      selectedList = exhibitions_24;
    }else if (_selectedDayIndex.toString() == '25') {
      selectedList = exhibitions_25;
    }else if (_selectedDayIndex.toString() == '26') {
      selectedList = exhibitions_26;
    }else if (_selectedDayIndex.toString() == '27') {
      selectedList = exhibitions_27;
    }else if (_selectedDayIndex.toString() == '28') {
      selectedList = exhibitions_28;
    }else if (_selectedDayIndex.toString() == '29') {
      selectedList = exhibitions_29;
    }else if (_selectedDayIndex.toString() == '30') {
      selectedList = exhibitions_31;
    }else if (_selectedDayIndex.toString() == '31') {
      selectedList = exhibitions_31;
    }else {
      selectedList = []; // 기본적으로 빈 리스트로 설정
    }

    return GestureDetector(
      onTap: () {

      },
      child: Container(
        height: 490,
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

    for (int i = 0; i < db_exhibi_date.length; i++) {
      String exhibiDate = db_exhibi_date[i]['exhibi_date'];
      print(getDayFromDate(exhibiDate));
      print('fetch 셀렉 월');
      print(widget.selectedDate.month);

      String selectedMonth = widget.selectedDate.month.toString();
      String selectedYear = widget.selectedDate.year.toString();

      String spaceName = db_spaceName[i]['spaceName'];
      String locationName = db_locationName[i]['locationName'];
      String image = db_image[i]['image'];
      String exhibiTag = db_exhibi_tag[i]['exhibi_tag'];
      String exhibiName = db_exhibi_name[i]['exhibi_name'];
      String exhibiloation = db_exhibi_location[i]['location'];

      Widget exhibitionWidget = WidgetExhibition(
        image,
        locationName,
        exhibiTag,
        exhibiName,
        exhibiDate,
        exhibiloation,

        onTap: () {
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

      // 날짜 며칠 비교
      if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '1') {
        exhibitions_1.add(exhibitionWidget);
      } else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '2'){
        exhibitions_2.add(exhibitionWidget);
      } else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '3'){
        exhibitions_3.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '4'){
        exhibitions_4.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '5'){
        exhibitions_5.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '6'){
        exhibitions_6.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth && getDayFromDate(exhibiDate) == '7'){
        exhibitions_7.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '8'){
        exhibitions_8.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '9'){
        exhibitions_9.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '10'){
        exhibitions_10.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '11'){
        exhibitions_11.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '12'){
        exhibitions_12.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '13'){
        exhibitions_13.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '14'){
        exhibitions_14.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '15'){
        exhibitions_15.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '16'){
        exhibitions_16.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '17'){
        exhibitions_17.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '18'){
        exhibitions_18.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '19'){
        exhibitions_19.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '20'){
        exhibitions_20.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '21'){
        exhibitions_21.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '22'){
        exhibitions_22.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '23'){
        exhibitions_23.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '24'){
        exhibitions_24.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '25'){
        exhibitions_25.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '26'){
        exhibitions_26.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '27'){
        exhibitions_27.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '28'){
        exhibitions_28.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '29'){
        exhibitions_29.add(exhibitionWidget);
      }else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '30'){
        exhibitions_30.add(exhibitionWidget);
      } else if(getYearFromDate(exhibiDate) == selectedYear && getMonthFromDate(exhibiDate) == selectedMonth &&getDayFromDate(exhibiDate) == '31'){
        exhibitions_31.add(exhibitionWidget);
      }

    }
    print('db 가져온 내용');
    print(db_exhibi_date);
    print(db_exhibi_name);
    print(db_exhibi_tag);

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
        height: MediaQuery.of(context).size.height * 0.7,
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