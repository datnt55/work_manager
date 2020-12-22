
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_manager_app/custom/dialog_date_time_picker.dart';

class EventAddScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24.0),

            child: EventFormWidget(),
          ),
        ),
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
  final format = DateFormat('EEE, dd MMM \t\t HH:mm');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 24),
                decoration: new InputDecoration.collapsed(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey.shade500)
                ),
              ),
            ),
            InkWell(
              child: Icon(Icons.circle, color: Colors.green,),
            )
          ],
        ),
        SizedBox(
          height: 32.0,
        ),
        Table(
          children: [
            TableRow(
                children: [
                  Text('Start'),
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      customBorder: new CircleBorder(),
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Text(format.format(startTime)),
                      ),
                    ),)
                ]
            ),
            TableRow(
                children: [
                  Expanded(child: Text('End'),),
                  Text('Test', textAlign:TextAlign.right)
                ]
            )

          ],
        )
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDateTimePicker(context: context);
    setState(() {
      startTime = picked;
    });
  }
}