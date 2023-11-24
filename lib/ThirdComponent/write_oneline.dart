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
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(8),
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

              SizedBox(height: 20,),

              GestureDetector(
                onTap: (){},

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("공간을 선택해주세요",style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 24,
                    ),),
                    Icon(
                      Icons.keyboard_arrow_down,
                    ),
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
                          onPressed: (){
                            _selectDate(context);
                          },
                          child: Text(DateFormat('yyyy년 MM월 dd일 방문').format(selectedDate),),
                        ),
                        IconButton(
                            onPressed: (){
                              _showCustomBottomSheet(context);
                            },
                            icon: Icon(
                              Icons.calendar_today_outlined,
                            )),
                      ],
                    ),
                  ),
              ),

              SizedBox(height: 10,),

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
                      border:InputBorder.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30,),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check,
                  ),
                  label: Text('안녕하세요'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300])),
                ),
              ),
            ],
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

}
