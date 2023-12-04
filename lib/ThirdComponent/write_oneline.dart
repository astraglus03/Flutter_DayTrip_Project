import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/model_db/onelinemodel.dart';
import 'package:final_project/model_db/space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_project/ThirdComponent/choose_space.dart';
import 'package:final_project/ThirdComponent/main_calender.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class WriteOneLine extends StatefulWidget {
  final SpaceModel? selectedSpace;

  WriteOneLine({
    this.selectedSpace,
  });

  @override
  State<WriteOneLine> createState() => _WriteOneLineState();
}

class _WriteOneLineState extends State<WriteOneLine> {
  DateTime selectedDate = DateTime.now();
  String? hashTagButton = '';
  late String? selectedImage;
  late String? selectedTitle;
  late String? selectedLocation;
  TextEditingController _textEditingController = TextEditingController();

  void selectButton(String buttonText) {
    setState(() {
      if (hashTagButton == buttonText) {
        hashTagButton = '';
      } else {
        hashTagButton = buttonText;
      }
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.selectedSpace != null) {
      selectedImage = widget.selectedSpace!.image;
      selectedTitle = widget.selectedSpace!.spaceName;
      selectedLocation = widget.selectedSpace!.locationName;
    }
    else{
      selectedImage = '';
      selectedTitle = '';
      selectedLocation = '';
    }
    initializeDateFormatting();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> createOneLine() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userCollectionRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final CollectionReference oneLineCollection = userCollectionRef.collection('oneLine');

    final DocumentReference spaceRef = userCollectionRef.collection('space').doc(selectedTitle);

    try {
      final DocumentSnapshot snapshot = await spaceRef.get();
      int? currentOid;
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        currentOid = data?['currentOid'] as int?;
      }

      // 만약 currentOid가 null이면 1로 초기화
      currentOid ??= 1;

      final String formattedDateString = DateFormat('yyyy년 MM월 dd일').format(selectedDate);
      final DateTime parsedDate = DateFormat('yyyy년 MM월 dd일').parse(formattedDateString);

      final oneLine = OneLineModel(
        oid: currentOid, // oid 설정
        uid: user.uid,
        date: parsedDate,
        spaceName: selectedTitle.toString(),
        tag: hashTagButton.toString(),
        oneLineContent: _textEditingController.text,
        locationName: selectedLocation.toString(),
      );

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(oneLineCollection.doc(oneLine.oid.toString()), oneLine.toJson());

        // 현재 oid 값 증가시키기
        await transaction.update(spaceRef, {'currentOid': (currentOid ?? 1) + 1});
      });
    } catch (e) {
      // 문서를 가져오는 도중에 오류 발생 시 처리할 내용
      print('Error fetching document: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.73,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 30,),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: selectedImage != null && selectedImage!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(selectedImage!, fit: BoxFit.cover),
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


                selectedTitle != null ?
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      '${selectedTitle}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ) :
                Container(),

                SizedBox(height: 20,),

                InkWell(
                  onTap: () async {
                    SpaceModel? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseSpace()),
                    );

                    if (result != null) {
                      setState(() {
                        selectedImage = result.image;
                        selectedTitle = result.spaceName;
                        selectedLocation = result.locationName;
                      });
                      print('전달받은 이미지: ${result.image}');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "공간을 선택하세요",
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
                    color: Colors.black26,
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
                          child: Text(
                            DateFormat('yyyy년 MM월 dd일').format(selectedDate),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showCustomBottomSheet(context);
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                          ),
                        ),
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
                    color: Colors.black26,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,),
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: '한 줄 메모 (최대 140줄)',
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
                    Navigator.pop(context);
                    createOneLine();
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pop();
                          });

                          return AlertDialog(
                            title: Text('한 줄 메모가 저장되었습니다'),
                            content: Text('마이페이지에서 확인하세요.'),
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
                        SizedBox(width: 8),
                        Text(
                          '한 줄 메모 ',
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
          color: Colors.black,
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
          color: Colors.white
        ),
      ),
      style: ButtonStyle(
        backgroundColor: hashTagButton == buttonText
            ? MaterialStateProperty.all<Color>(Colors.blue)
            : MaterialStateProperty.all<Color>(Colors.transparent),
        side: MaterialStateProperty.all(BorderSide(
          color: Colors.white,
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