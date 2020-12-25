
import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/base_bloc/base.dart';
import 'package:work_manager_app/bloc/schedule/scheldule_bloc.dart';
import 'package:work_manager_app/database/event.dart';

import 'file:///D:/Android/flutter/Example/WorkManager/work_manager/lib/feature/event/dialog_date_time_picker.dart';

import 'event_color_dialog.dart';

class EventAddScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: EventFormWidget(),
      ),
    );
  }
}

class EventFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventFormState();

}

class EventFormState extends State<EventFormWidget>{
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Color eventColor = Colors.lightBlueAccent;
  final myController = TextEditingController();
  final format = DateFormat('EEE, dd MMM \t\t HH:mm');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleBloc(),
      child: BlocBuilder<ScheduleBloc, BaseState>(
        builder: (context, state) {
          if (state is InitState){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 24),
                            decoration: new InputDecoration.collapsed(
                                hintText: 'Title',
                                hintStyle: TextStyle(color: Colors.grey.shade500)
                            ),
                            controller: myController,
                          ),
                        ),
                        InkWell(
                          customBorder: new CircleBorder(),
                          onTap: (){
                            _selectColor(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(3.0),
                            child: Center(child:  Icon(Icons.circle, color: eventColor,),),
                          )
                        )
                      ],
                    ),
                  ),flex: 1,
                ),
                Expanded(
                  child: Table(
                    children: [
                      TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: Text('Start'),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                customBorder: new CircleBorder(),
                                onTap: (){
                                  _selectDate(context, START_TIME);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                  child: Text(format.format(startTime)),
                                ),
                              ),)
                          ]
                      ),
                      TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: Text('End'),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                customBorder: new CircleBorder(),
                                onTap: (){
                                  _selectDate(context, END_TIME);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                  child: Text(format.format(endTime)),
                                ),
                              ),)
                          ]
                      )
                    ],
                  ),flex: 5,
                ),
                Flexible(
                  child:  Container(
                    height: 60,
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: (){
                                  Navigator.pop(context, false);
                                },
                                child: Container(
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text('Cancel',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent, fontSize: 19, fontWeight: FontWeight.w500),),)
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: (){
                                  if (endTime.difference(startTime).inMinutes < 1) {
                                    final snackBar = SnackBar(
                                      padding: EdgeInsets.all(8.0),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Create Event Error'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }else {
                                    final event = new Event(myController.text, startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch, eventColor.value);
                                    context.read<ScheduleBloc>().add(SaveSchedule(event));
                                  }
                                },
                                child: Container(
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text('Save',textAlign: TextAlign.center,style: TextStyle(color: Colors.blueAccent, fontSize: 19, fontWeight: FontWeight.w500),),)
                              ),
                          ),
                        )
                      ],
                    ),
                  ),flex: 1,
                )
              ],
            );
          }else if (state is AddScheduleSuccessState){
            new Timer(const Duration(milliseconds: 10), () {
              Navigator.pop(context, true);
            });
          }
          return Container();
        },
      ),
    );
  }

  _selectDate(BuildContext context, int position) async {
    final DateTime picked = await showDateTimePicker(context: context);
    if (picked == null)
      return;
    if (position == START_TIME)
      setState(() {
        startTime = picked;
      });
    else
      setState(() {
        endTime = picked;
      });
  }

  _selectColor(BuildContext context) async {
    final Color color = await showEventColorDialog(context: context);
    if (color != null) {
      setState(() {
        eventColor = color;
      });
    }
  }
}

const int START_TIME = 1;
const int END_TIME = 2;
