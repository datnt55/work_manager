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

class RowTableDateWidgetBloc extends StatelessWidget {
  RowTableDateWidgetBloc(this.scheduleBloc, this._scrollController);

  final ScheduleBloc scheduleBloc;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DateEventCubit(),
        child: BlocBuilder<DateEventCubit, DateTime>(builder: (_, date) {
          return BlocProvider(
              create: (context) => scheduleBloc,
              child: BlocBuilder<ScheduleBloc, BaseState>(
                builder: (context, state) {
                  if (state is LoadedState<List<Event>>) {
                    return Container(
                      height: 55 * 24.0,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: _calculateEventOverLap(context, state.data, _scrollController),
                      ),
                    );
                  } else if (state is InitState) {
                    context.watch<ScheduleBloc>().add(FetchSchedule());
                    return Container();
                  } else if (state is UpdateScheduleSuccessState) {
                    context.watch<ScheduleBloc>().add(FetchSchedule());
                    return Container();
                  } else
                    return Container();
                },
              ));
        }));
  }
}

List<Widget> _calculateEventOverLap(BuildContext context, List<Event> events, ScrollController _scrollController) {
  int index = 0;
  List<Widget> eventWidget = new List();
  while (index < events.length) {
    int total = 1;
    if (index < events.length - 1) {
      while (calculateOverlap(events[index], events[index + total])) {
        total++;
        if (index + total >= events.length) break;
      }
    }

    for (int i = 0; i < total; i++) {
      var startDate = new DateTime.fromMillisecondsSinceEpoch(events[i + index].fromDate);
      var endDtae = new DateTime.fromMillisecondsSinceEpoch(events[i + index].endDate);
      final start = 55.0 * startDate.hour + 55.0 * startDate.minute / 60.0;
      final end = 55.0 * endDtae.hour + 55.0 * endDtae.minute / 60.0;
      final now = new DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final width = (MediaQuery.of(context).size.width - 32.0) / 7;
      Offset offset = Offset.zero;
      double x = width * startDate.differenceMidNight(monday).inDays + width / total * i;
      double y = start;
      var event = EventWidget(_scrollController, events[i + index], total, x, y);
      eventWidget.add(event);
    }
    index += total;
  }
  return eventWidget;
}

class EventWidget extends StatefulWidget {
  EventWidget(this._scrollController, this.event, this.total, this.x, this.y);

  final Event event;
  final int total;
  final double x;
  final double y;

  final ScrollController _scrollController;

  @override
  @override
  State<EventWidget> createState() => _EventState(_scrollController, event, total, x, y);
}

class _EventState extends State<EventWidget> {
  final Event event;
  final int total;
  final ScrollController _scrollController;
  double x = 0, y = 0;
  double originX = 0, originY = 0;

  _EventState(this._scrollController, this.event, this.total, this.x, this.y) {}

  @override
  Widget build(BuildContext context) {
    var startDate = new DateTime.fromMillisecondsSinceEpoch(event.fromDate);
    var endDtae = new DateTime.fromMillisecondsSinceEpoch(event.endDate);
    final start = 55.0 * startDate.hour + 55.0 * startDate.minute / 60.0;
    final end = 55.0 * endDtae.hour + 55.0 * endDtae.minute / 60.0;
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final width = (MediaQuery.of(context).size.width - 32.0) / 7;
    return Positioned(
        top: y,
        left: x,
        child: GestureDetector(
          child: Container(
              margin: EdgeInsets.all(1.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0)), color: Color(event.color)),
              width: (width - 2.0 * (total)) / total,
              height: end - start - 2.0,
              child: Builder(builder: (context) {
                final textSize = 10.0;
                return Center(
                  child: Text(
                    event.title,
                    style: TextStyle(color: Colors.white, fontSize: textSize),
                    textAlign: TextAlign.center,
                  ),
                );
              })),
          onLongPressStart: (details) {
            originX = x;
            originY = y;
          },
          onLongPressMoveUpdate: (details) {
            //print('----- time: $y');
            // print('Global position ${details.globalPosition}');
            // print('Local position ${details.localPosition}');
            // print('Offset global ${details.offsetFromOrigin}');
            // print('Offset local ${details.localOffsetFromOrigin}');
            // print('scroll ${_scrollController.position.pixels}');

            if (y > _scrollController.position.pixels + 450) {
              y = originY + details.offsetFromOrigin.dy + 16.toDouble();
              x = originX + details.offsetFromOrigin.dx;
             // print('----- Current Y plus : $y');
              _scrollController.jumpTo(_scrollController.position.pixels + 5);
            } else if (y  < _scrollController.position.pixels + 20) {
              _scrollController.jumpTo(_scrollController.position.pixels - 5);
              y = originY + details.offsetFromOrigin.dy - 5.toDouble();
              x = originX + details.offsetFromOrigin.dx;
            } else {
             // print('----- Current Y : $y');
              x = originX + details.offsetFromOrigin.dx;
              y = originY + details.offsetFromOrigin.dy+ 16.toDouble();
              _scrollController.jumpTo(_scrollController.position.pixels + 5);
            }
            setState(() {});
          },
          onLongPressEnd:(detail){
            int hour = y~/55;
            int minutes = (y - hour*55).round();
            int day = x~/width;
            event.fromDate = DateTime(startDate.year, startDate.month, monday.add(Duration(days: day)).day, hour, minutes).millisecondsSinceEpoch;
            event.endDate = event.fromDate + endDtae.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch;
            context.read<ScheduleBloc>().add(UpdateSchedule(event));
          },
        ));
  }
}

bool calculateOverlap(Event first, Event second) {
  var startDate1 = new DateTime.fromMillisecondsSinceEpoch(first.fromDate);
  var endDtae1 = new DateTime.fromMillisecondsSinceEpoch(first.endDate);
  final start1 = 55.0 * startDate1.hour + 55.0 * startDate1.minute / 60.0;
  final end1 = 55.0 * endDtae1.hour + 55.0 * endDtae1.minute / 60.0;

  var startDate2 = new DateTime.fromMillisecondsSinceEpoch(second.fromDate);
  var endDtae2 = new DateTime.fromMillisecondsSinceEpoch(second.endDate);
  final start2 = 55.0 * startDate2.hour + 55.0 * startDate2.minute / 60.0;
  final end2 = 55.0 * endDtae2.hour + 55.0 * endDtae2.minute / 60.0;

  if (!startDate1.isSameDate(startDate2)) return false;
  if (end1 < start2) return false;
  return true;
}

class TodayLineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    double position = now.hour * 55.0 + now.minute / 60.0 * 55.0;
    final width = (MediaQuery.of(context).size.width - 32.0) / 7;
    return Positioned(
        top: position - 5,
        left: width * now.differenceMidNight(monday).inDays,
        width: width,
        height: 10,
        child: CustomPaint(painter: ArrowPainter(width)));
  }
}
