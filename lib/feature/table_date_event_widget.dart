import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_manager_app/bloc/base_bloc/base_state.dart';
import 'file:///D:/Android/flutter/Example/WorkManager/work_manager/lib/custom/arrow_painter.dart';
import 'package:work_manager_app/bloc/event_date_select_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/schedule/scheldule_bloc.dart';
import 'package:work_manager_app/bloc/table_zoom_cubit.dart';
import 'package:work_manager_app/database/event.dart';
import '../line_dashed_painter.dart';
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
                List<Positioned> eventWidget = new List();
                if (state is LoadedState<List<Event>>){
                  for (Event event in state.data){
                    var startDate = new DateTime.fromMillisecondsSinceEpoch(event.fromDate);
                    var endDtae = new DateTime.fromMillisecondsSinceEpoch(event.endDate);
                    final start = 55.0* startDate.hour + 55.0*startDate.minute/60.0 ;
                    final end = 55.0* endDtae.hour + 55.0*endDtae.minute/60.0;
                    final now = new DateTime.now();
                    final monday = now.subtract(Duration(days: now.weekday-1));
                    final width =  (MediaQuery.of(context).size.width - 32.0)/7;
                    final eventPost = Positioned(
                        top: start,
                        left: width*startDate.differenceMidNight(monday).inDays,
                        child: LongPressDraggable(
                          childWhenDragging: Container(),
                          feedback: Center(
                            child: Container(
                                margin: EdgeInsets.all(1.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0)), color:Color(event.color)),
                                width: width - 2.0,
                                height: end - start - 4.0,
                                child: Builder(builder: (context){
                                  final textSize = 10.0;
                                  return Center(
                                    child: Text(event.title, style: TextStyle(color: Colors.white, fontSize: textSize),textAlign: TextAlign.center,),
                                  );
                                })
                            ),
                          ),
                          child: Center(
                            child: Container(
                                margin: EdgeInsets.all(1.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0)), color:Color(event.color)),
                                width: width - 2.0,
                                height: end - start - 4.0,
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

                        )
                    );
                    eventWidget.add(eventPost);
                  }
                  return  Container(
                    height: 55*24.0,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: eventWidget,
                    ),
                  );
                }else if (state is InitState){
                  context.watch<ScheduleBloc>().add(FetchSchedule());
                  return Container();
                }else
                  return Container();
              },
          ));
        })
    );
  }
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