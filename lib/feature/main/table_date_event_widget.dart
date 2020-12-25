import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_manager_app/bloc/base_bloc/base_state.dart';
import 'file:///D:/Android/flutter/Example/WorkManager/work_manager/lib/custom/arrow_painter.dart';
import 'package:work_manager_app/bloc/event_date_select_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/schedule/scheldule_bloc.dart';
import 'package:work_manager_app/bloc/table_zoom_cubit.dart';
import 'package:work_manager_app/database/event.dart';
import 'package:work_manager_app/extensions.dart';
import 'package:work_manager_app/extensions.dart';

class RowTableDateWidgetBloc extends StatelessWidget{
  RowTableDateWidgetBloc(this.scheduleBloc);
  final ScheduleBloc scheduleBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DateEventCubit(),
        child: BlocBuilder<DateEventCubit, DateTime>(builder: (_, date){
          return BlocProvider(
              create: (context) => scheduleBloc,
              child: BlocBuilder<ScheduleBloc, BaseState>(
              builder: (context, state){
                if (state is LoadedState<List<Event>>){
                  return  Container(
                    height: 55*24.0,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: _calculateEventOverLap(context, state.data),
                    ),
                  );
                }else if (state is InitState){
                  context.watch<ScheduleBloc>().add(FetchSchedule());
                  return Container();
                }else if (state is UpdateScheduleSuccessState){
                  context.watch<ScheduleBloc>().add(FetchSchedule());
                  return Container();
                }
                else
                  return Container();
              },
          ));
        })
    );
  }
}

List<Positioned> _calculateEventOverLap(BuildContext context, List<Event> events){
  int index = 0;
  List<Positioned> eventWidget = new List();
  while(index < events.length){
    int total = 1;
    if (index < events.length - 1) {
      while (calculateOverlap(events[index], events[index + total])) {
        total ++;
        if (index + total >= events.length)
          break;
      }
    }

    for (int i =  0; i < total; i++){
      final event = events[i + index];
      var startDate = new DateTime.fromMillisecondsSinceEpoch(event.fromDate);
      var endDtae = new DateTime.fromMillisecondsSinceEpoch(event.endDate);
      final start = 55.0* startDate.hour + 55.0*startDate.minute/60.0 ;
      final end = 55.0* endDtae.hour + 55.0*endDtae.minute/60.0;
      final now = new DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday-1));
      final width =  (MediaQuery.of(context).size.width - 32.0)/7;
      Offset offset = Offset.zero;
      final eventPost = Positioned(
          top: start,
          left: width*startDate.differenceMidNight(monday).inDays +  width/total*i,
          child: LongPressDraggable(
            childWhenDragging: Container(),
            feedback: Center(
              child: Container(
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0)), color:Color(event.color)),
                  width: (width- 2.0*(total))/total ,
                  height: end - start - 2.0,
                  child: Builder(builder: (context){
                    final textSize = 10.0;
                    return Center(
                      child: Text(event.title, style: TextStyle(color: Colors.white, fontSize: textSize),textAlign: TextAlign.center,),
                    );
                  })
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  margin: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0)), color:Color(event.color)),
                  width: (width- 2.0*(total))/total ,
                  height: end - start - 2.0,
                  child: Builder(builder: (context){
                    final scale = context.watch<TableZoomCubit>().zoomLevel;
                    print(scale);
                    final textSize = 10.0;
                    return Center(
                      child: Text(event.title, style: TextStyle(color: Colors.white, fontSize: textSize),textAlign: TextAlign.center,),
                    );
                  })
              ),
            ),
            onDragEnd: (detail){
              int hour = detail.offset.dy~/55;
              int minutes = (detail.offset.dy - hour*55).toInt();
              int day = detail.offset.dx~/width;
              event.fromDate = DateTime(startDate.year, startDate.month, monday.add(Duration(days: day)).day, hour, minutes).millisecondsSinceEpoch;
              event.endDate = event.fromDate + endDtae.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch;
              context.read<ScheduleBloc>().add(UpdateSchedule(event));
            },
          )
      );
      eventWidget.add(eventPost);
    }
    index += total;
  }
  return eventWidget;
}

bool calculateOverlap(Event first, Event second){
  var startDate1 = new DateTime.fromMillisecondsSinceEpoch(first.fromDate);
  var endDtae1 = new DateTime.fromMillisecondsSinceEpoch(first.endDate);
  final start1 = 55.0* startDate1.hour + 55.0*startDate1.minute/60.0 ;
  final end1 = 55.0* endDtae1.hour + 55.0*endDtae1.minute/60.0;

  var startDate2 = new DateTime.fromMillisecondsSinceEpoch(second.fromDate);
  var endDtae2 = new DateTime.fromMillisecondsSinceEpoch(second.endDate);
  final start2 = 55.0* startDate2.hour + 55.0*startDate2.minute/60.0 ;
  final end2 = 55.0* endDtae2.hour + 55.0*endDtae2.minute/60.0;

  if (!startDate1.isSameDate(startDate2))
    return false;
  if (end1 < start2)
    return false;
  return true;
}

class TodayLineWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday-1));
    double position = now.hour*55.0 + now.minute/60.0*55.0;
    final width =  (MediaQuery.of(context).size.width - 32.0)/7;
    return Positioned(
        top: position - 5,
        left: width*now.differenceMidNight(monday).inDays,
        width: width,
        height: 10,
        child: CustomPaint(painter: ArrowPainter(width))
    );
  }

}