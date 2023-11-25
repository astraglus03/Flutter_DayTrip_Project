import 'package:final_project/ThirdComponent/choose_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_project/ThirdComponent/main_calender.dart';
import 'package:intl/intl.dart';

class WriteOneLine extends StatefulWidget {


  const WriteOneLine({super.key});

  @override
  State<WriteOneLine> createState() => _WriteOneLineState();
}

class _WriteOneLineState extends State<WriteOneLine> {

  String? selectedImage;
  String? selectedTitle;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  String? hashTagButton = '';

  // 해시태그 버튼
  void selectButton(String buttonText) {
    setState(() {
      if (hashTagButton == buttonText) {
        hashTagButton = ''; // 이미 선택된 버튼을 다시 누르면 선택 해제
      } else {
        hashTagButton = buttonText; // 새로운 버튼을 선택
      }
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // 위젯이 dispose 될 때 FocusNode를 해제합니다.
    _focusNode.dispose();
    super.dispose();
  }


    @override
    Widget build(BuildContext context) {
      print(selectedImage);
      print(selectedTitle);
      return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(selectedImage!, fit: BoxFit.cover),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.place,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  selectedTitle !=null ?
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text( selectedTitle !=null ? '${selectedTitle}' : '' , style: TextStyle(
                        fontSize: 24,
                      ),),
                    ),
                  ) :
                      Container(),

                  SizedBox(height: 20,),

                  InkWell(
                    onTap: () async {
                      // ChooseSpace 화면으로 이동하여 이미지 선택
                      SpaceInfo? result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseSpace()),
                      );

                      // Check if result is not null and contains selected space info
                      if (result != null) {
                        setState(() {
                          selectedImage = result.imagePath;
                          // Use result.title as needed in your logic
                          // For example, assign it to a variable or update the UI
                          selectedTitle = result.title;
                        });
                      }

                      print('텍스트와 아이콘이 클릭되었습니다!');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "공간을 선택해주세요",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 24,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),

                  SizedBox(height: 40,),

                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[300],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(DateFormat('yyyy년 MM월 dd일 방문').format(
                                selectedDate), style: TextStyle(
                              color: Colors.black,
                            ),),
                          ),
                          IconButton(
                              onPressed: () {
                                _showCustomBottomSheet(context);
                              },
                              icon: Icon(
                                Icons.calendar_today_outlined,
                              )),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '한 줄 메모(140자까지 입력 가능)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  Row(
                    children: [
                      buildButton('카페'),
                      SizedBox(width: 10),
                      buildButton('음식점'),
                      SizedBox(width: 10),
                      buildButton('편의점'),
                      SizedBox(width: 10),
                      buildButton('학교건물'),
                      SizedBox(width: 10),
                      buildButton('주차장'),
                      SizedBox(width: 10),
                    ],
                  ),


                  SizedBox(height: 20,),

                  InkWell(
                    onTap: () {
                      // 데이터베이스에 보내기 OR 정보 마이페이지로 넘겨주기.

                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });

                            return AlertDialog(
                              title: Text('한 줄 메모 되었습니다!'),
                              content: Text('마이페이지에서 확인 하십시오.'),
                            );
                          }
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 조절
                          Text(
                            '한 줄 평 남기기',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    }

    void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
      setState(() {
        this.selectedDate = selectedDate;
        Navigator.pop(context);
      });
    }

    void _showCustomBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return MainCalender(
              onDaySelected: onDaySelected,
              selectedDate: selectedDate
          );
        },
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      DateTime? pickedDate = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          );
        },
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    Widget buildButton(String buttonText) {
      return TextButton(
        onPressed: () {
          selectButton(buttonText);
        },
        child: Text(
          buttonText,
          style: TextStyle(
            color: hashTagButton == buttonText ? Colors.white : Colors.black,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: hashTagButton == buttonText
              ? MaterialStateProperty.all<Color>(Colors.blue) // 선택된 버튼의 배경색
              : MaterialStateProperty.all<Color>(Colors.transparent),
          side: MaterialStateProperty.all(BorderSide(
            color: Colors.black,
            width: 1.0,
          )),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      );
    }
}
