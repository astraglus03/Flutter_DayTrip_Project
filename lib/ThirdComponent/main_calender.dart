import 'package:flutter/material.dart';
import 'package:final_project/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalender extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  MainCalender({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            TableCalendar(
              onDaySelected: onDaySelected,
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
    );;
  }

}
