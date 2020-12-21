import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_manager_app/bloc/arrow_painter.dart';
import 'package:work_manager_app/bloc/event_date_select_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/table_zoom_cubit.dart';
import '../line_dashed_painter.dart';
import 'package:work_manager_app/extensions.dart';

class RowTableDateWidgetBloc extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday-1));
    return BlocProvider(
        create: (_) => DateEventCubit(),
        child: BlocBuilder<DateEventCubit, DateTime>(builder: (_, state){
          return Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  for (int j = 0 ; j < 7; j++)
                      Expanded(child: RowTableDateWidget(rowDate: monday.add(Duration(days: j)),),flex: 1,)
                ],
              )
          );
        })
    );
  }
}

class RowTableDateWidget extends StatelessWidget {
  RowTableDateWidget({this.rowDate});

  final DateTime rowDate;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DateEventCubit>().current;
    return Container(
      height: (55*24).toDouble(),
      decoration: BoxDecoration(border: Border(left: BorderSide(width: 0.5, color: Colors.grey.shade300))),
      child: Stack(
        children: [
          Stack(
            children: [
              for (int i = 0 ; i < 24; i++)
                Positioned(
                    left: 0,
                    top: (55*i).toDouble(),
                    child: Builder(builder: (context){
                      final currentTime = DateTime(rowDate.year, rowDate.month, rowDate.day,i,0,0);
                      if (state != null && currentTime.difference(state).inMilliseconds == 0)
                        return InkWell(
                            onTap: (){
                              final currentTime = DateTime(rowDate.year, rowDate.month, rowDate.day,i,0,0);
                              context.read<DateEventCubit>().setCurrentDate(currentTime);
                            },
                            child:  Container(
                              width: 51,
                              height: 55,
                              decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: Colors.grey.shade300))),
                              child: Container(
                                margin: EdgeInsets.all(2.0),
                                width: 47,
                                height: 47,
                                decoration: BoxDecoration(color : Colors.green.withOpacity(0.4),border: Border.all(color: Colors.green, width: 2.0), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                child: Center(
                                  child: Icon(Icons.add, color: Colors.white,),
                                ),
                              ),
                            )
                        );
                      else
                        return InkWell(
                            onTap: (){
                              final currentTime = DateTime(rowDate.year, rowDate.month, rowDate.day,i,0,0);
                              context.read<DateEventCubit>().setCurrentDate(currentTime);
                            },
                            child:  Container(
                              width: 150,
                              height: 55,
                              decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: Colors.grey.shade300))),
                            )
                        );
                    })
                ),
              for (int i = 0 ; i < 24; i++)
                Positioned(
                    left: 0,
                    top: (27.5 + 55*i).toDouble(),
                    width: 150,
                    child: CustomPaint(painter: LineDashedPainter())
                ),
              Builder(builder: (_){
                if (DateTime.now().isSameDate(rowDate)){
                  return Positioned(
                      top: (55*3 + 20).toDouble(),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.green.shade300),
                          width: 42,
                          height: 55*1.5 - 4.0,
                          child: Text('Meeting công ty A', style: TextStyle(color: Colors.white, fontSize: 10),textAlign: TextAlign.center,),
                        ),
                      )
                  );
                }else
                  return Container();
              }),
              Builder(builder: (_){
                if (DateTime.now().difference(rowDate).inDays == -4){
                  return Positioned(
                      top: (55*7).toDouble(),
                      child: Center(
                        child: Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.lightBlueAccent.shade400),
                            width: 47,
                            height: 55*2 - 4.0,
                            child: Builder(builder: (context){
                              final scale = context.watch<TableZoomCubit>().zoomLevel;
                              print(scale);
                              final textSize = 10.0;
                              return Center(
                                child: Text('Họp đại hội cấp cao', style: TextStyle(color: Colors.white, fontSize: textSize),textAlign: TextAlign.center,),
                              );
                            })
                        ),
                      )
                  );
                }else
                  return Container();
              }),
              TodayLineWidget(rowDate: rowDate,),
            ],
          )
        ],
      ),
    );
  }
}

class TodayLineWidget extends StatelessWidget{
  TodayLineWidget({this.rowDate});

  final DateTime rowDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (now.isSameDate(rowDate)){
      double position = now.hour*55.0 + now.minute/60.0*55.0;
      return Positioned(
          top: position - 5,
          width: 55,
          height: 10,
          child: CustomPaint(painter: ArrowPainter())
      );
    }else
      return Container();
  }

}