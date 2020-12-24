
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_manager_app/extensions.dart';

Future<DateTime> showDateTimePicker({BuildContext context,}) async {
  Widget dialog = _DateTimePickerDialog();

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

class _DateTimePickerDialog extends StatefulWidget{
  @override
  DatePickerDialogState createState() => DatePickerDialogState();

}

const Size _calendarPortraitDialogSize = Size(330.0, 518.0);

class DatePickerDialogState extends State<_DateTimePickerDialog>{
  DateTime current = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _calendarPortraitDialogSize * textScaleFactor;
    return Dialog(
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: Builder(builder: (BuildContext context) {
            return Column(
              children: [
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: new DateTime(2000,01,01),
                  onDateChanged: (DateTime value) {
                    current = current.copyWith(day: value.day, month: value.month, year: value.year);
                    print(value);
                  },
                  lastDate: new DateTime(2100,01,01),
                ),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    minuteInterval: 1,
                    backgroundColor: Colors.white,
                    onDateTimeChanged: (data) {
                      current = current.copyWith(hour: data.hour, minute: data.minute);
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        customBorder: new CircleBorder(),
                        child: Text('Cancel',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent, fontSize: 19, fontWeight: FontWeight.w500),),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context,current);
                        },
                        child: Text('Done',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent, fontSize: 19, fontWeight: FontWeight.w500),),
                      ),
                    )
                  ],
                )
              ],
            );
          }),
        ),
        margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        duration: Duration(seconds: 300),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
    );
  }

}