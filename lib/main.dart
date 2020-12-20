import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/date_select_cubit.dart';
import 'package:work_manager_app/bloc/event_date_select_cubit.dart';
import 'package:work_manager_app/bloc/table_zoom_cubit.dart';

import 'line_dashed_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.menu,  color: Colors.grey.shade800,), // change this size and style
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DEC', style: TextStyle(color: Colors.grey.shade800, fontSize: 24, fontWeight: FontWeight.w300),),
            SizedBox(width: 12,),
            Container(
              margin: EdgeInsets.only(bottom: 3.0),
              child: Text('2020', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w300),),
            )
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        toolbarHeight: 70,
        shadowColor: Colors.transparent,

      ),
      drawer: DrawerWidget(),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child:  Container(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(24.0))
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 24, right: 16, top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0 ; i < 8; i++)
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context){
                              if (i == 6)
                                return Text(convertToDay(i), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),);
                              return Text(convertToDay(i), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w400),);
                            },
                          )
                      )
                  ],
                ),
              ),
              DateTableWidget(),
              Container(
                color: Colors.grey.shade500,
                height: 0.7,
              ),
              Expanded(child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment:  CrossAxisAlignment.end,
                      children: [
                        for (int i = 0 ; i < 24; i++)
                          Builder(builder: (_){
                            if (i == 0) {
                              return Container(
                                padding: EdgeInsets.only(right: 4),
                                height: 47,
                              );
                            }else
                              return Container(
                                padding: EdgeInsets.only(right: 4),
                                height: 55,
                                child: Text('$i', textAlign: TextAlign.end, style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),),
                              );
                          })
                      ],
                    ),
                    Expanded(child: TableViewWidget())
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          child: new Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: (){}
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  String convertToDay(int i) {
    switch (i){
      case 0 :
        return "M";
      case 1 :
        return "T";
      case 2 :
        return "W";
      case 3 :
        return "T";
      case 4 :
        return "F";
      case 5 :
        return "S";
      case 6 :
        return "S";
      default:
        return "";
    }
  }
}

class DateTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday-1));

    return BlocProvider(
        create: (_) => DateCubit(),
        child: BlocBuilder<DateCubit, DateTime>(builder: (_, state) {
          return Container(
            padding: EdgeInsets.only(top:4, left: 24, right: 16),
            child: Table(
              children: [
                TableRow(
                    children: [
                      for (int i = 0 ; i < 7; i++)
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context){
                                final currentDay = monday.add(Duration(days: i));
                                // Handle case Sunday
                                if (i == 6) {
                                  // Handle case Sunday is today
                                  if (currentDay.difference(now).inDays == 0)
                                    if (state.difference(currentDay).inDays == 0){
                                      return InkWell(
                                          onTap:() {
                                            context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(padding: EdgeInsets.all(2.0),
                                                  width: 24,
                                                  decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                  child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                                                ),
                                              )
                                          )
                                      );
                                    }else{
                                      return InkWell(
                                          onTap:() {
                                            context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                                              width: double.infinity,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(padding: EdgeInsets.all(2.0),
                                                  width: 24,
                                                  decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                  child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                                                ),
                                              )
                                          )
                                      );
                                    }
                                  else
                                  if (state.difference(currentDay).inDays == 0){
                                    return InkWell(
                                      onTap:() {
                                        context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                      },
                                      child:  Container(
                                          padding: EdgeInsets.only(left: 2, bottom: 4, top: 4),
                                          width: double.infinity,
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),),
                                          )
                                      ),
                                    );
                                  }else{
                                    return InkWell(
                                      onTap:() {
                                        context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                      },
                                      child:  Container(
                                          padding: EdgeInsets.only(left: 2, bottom: 4, top: 4),
                                          width: double.infinity,
                                          decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),),
                                          )
                                      ),
                                    );
                                  }
                                }
                                else if (i == 7)
                                  return Text('');
                                // Case normal day in week is today
                                if (currentDay.difference(now).inDays == 0)
                                  if (state.difference(currentDay).inDays == 0){
                                    return InkWell(
                                        onTap:() {
                                          context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                                            width: double.infinity,
                                            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(padding: EdgeInsets.all(2.0),
                                                width: 24,
                                                decoration: const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                                              ),
                                            )
                                        )
                                    );
                                  }else{
                                    return InkWell(
                                        onTap:() {
                                          context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                                            width: double.infinity,
                                            decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(padding: EdgeInsets.all(2.0),
                                                width: 24,
                                                decoration: const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                                child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                                              ),
                                            )
                                        )
                                    );
                                  }
                                else
                                  // Case normal day in week is not today
                                  if (state.difference(currentDay).inDays == 0){
                                    return InkWell(
                                      onTap:() {
                                        context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                      },
                                      child:  Container(
                                          padding: EdgeInsets.only(left: 2, bottom: 4, top: 4),
                                          width: double.infinity,
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.grey.shade900, fontSize: 12, fontWeight: FontWeight.w400),),
                                          )
                                      ),
                                    );
                                  }else{
                                    return InkWell(
                                      onTap:() {
                                        context.read<DateCubit>().setCurrentDate(monday.add(Duration(days: i)));
                                      },
                                      child:  Container(
                                          padding: EdgeInsets.only(left: 2, bottom: 4, top: 4),
                                          width: double.infinity,
                                          decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Text(currentDay.day.toString(), style: TextStyle(color: Colors.grey.shade900, fontSize: 12, fontWeight: FontWeight.w400),),
                                          )
                                      ),
                                    );
                                  }

                              },
                            )
                        )
                    ]
                )
              ],
            ),
          );

    }));

  }

}

class TableViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TransformationController();
    return BlocProvider(
        create: (_) => TableZoomCubit(),
        child: BlocBuilder<TableZoomCubit, double>(builder: (_, state){
            return Builder(builder: (context){
              return InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 3.5,
                  scaleEnabled: true,
                  constrained: true,
                  boundaryMargin: EdgeInsets.all(0.0),
                  transformationController: controller,
                  onInteractionStart: (start){

                  },
                  onInteractionUpdate: (details) {
                    context.read<TableZoomCubit>().setZoomLevel(details.scale);
                  },
                  onInteractionEnd: (end){
                  },
                  child:Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          for (int j = 0 ; j < 7; j++)
                            if (j <6)
                              Expanded(child: RowTableDateWidget(index: j,),flex: 1,)
                            else
                              Expanded(child: Container(
                                height: (55*24).toDouble(),
                                child: RowTableDateWidget(index: j),
                              ),flex: 1,)
                        ],
                      )
                  )
              );
            });
      })
    );
  }
}

class RowTableDateWidget extends StatelessWidget {
  RowTableDateWidget({this.index});

  final index;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DateEventCubit(),
    child: BlocBuilder<DateEventCubit, DateTime>(builder: (_, state){
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
                      top: (55*(i+1)).toDouble(),
                      child: Builder(builder: (context){
                        return InkWell(
                          onTap: (){
                            final now = DateTime.now();
                            final lastMidnight = new DateTime(now.year, now.month, now.day, i, 0 ,0);
                            context.read<DateEventCubit>().setCurrentDate(lastMidnight);
                          },
                          child: Builder(builder: (context){
                            final now = DateTime.now();
                            final lastMidnight = new DateTime(now.year, now.month, now.day, i, 0 ,0);
                            print(state.toString());
                            print('Current ${state.toString()}');
                            if (lastMidnight.difference(state).inMilliseconds == 0){
                              return Container(
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
                              );

                            }else{
                              return Container(
                                width: 150,
                                height: 55,
                                decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: Colors.grey.shade300))),
                              );
                            }
                          }),
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
                  if (index == 2){
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
                  if (index == 5){
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
              ],
            )
          ],
        ),
      );
    })
    );

  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}
