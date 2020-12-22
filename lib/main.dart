import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_manager_app/bloc/table_zoom_cubit.dart';
import 'package:work_manager_app/common_utils.dart';
import 'package:work_manager_app/feature/event/add_event_screen.dart';

import 'bloc/current_timer_cubit.dart';
import 'feature/day_row_widget.dart';
import 'feature/main_drawer_widget.dart';
import 'feature/table_date_event_widget.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrentTimeCubit(),
      child: BlocBuilder<CurrentTimeCubit, DateTime>(
        builder: (_, time) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
                padding: EdgeInsets.only(left: 32, right: 16, top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0 ; i < 8; i++)
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context){
                              if (i == 6)
                                return Text(CommonUtils.convertToDay(i), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),);
                              return Text(CommonUtils.convertToDay(i), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w400),);
                            },
                          )
                      )
                  ],
                ),
              ),
              DateTableWidget(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                color: Colors.grey.shade500,
                height: 0.7,
              ),
              Expanded(child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment:  CrossAxisAlignment.end,
                            children: [
                              for (int i = 0 ; i < 24; i++)
                                Builder(builder: (_){
                                  final now = DateTime.now();
                                  if (i == 0) {
                                    return Container(
                                      padding: EdgeInsets.only(right: 4),
                                      height: 47,
                                    );
                                  }else {
                                    // Hide hour when current minutes less than 10 or more than 50
                                    if (now.hour == i && now.minute <10){
                                      return Container(
                                        padding: EdgeInsets.only(right: 4),
                                        height: 55,
                                      );
                                    }
                                    if (now.hour == i-1 && now.minute >50){
                                      return Container(
                                        padding: EdgeInsets.only(right: 4),
                                        height: 55,
                                      );
                                    }
                                    return Container(
                                      padding: EdgeInsets.only(right: 4),
                                      height: 55,
                                      child: Text('$i', textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 11),),
                                    );
                                  }
                                })
                            ],
                          ),
                          Builder(builder: (_){
                            final now = context.read<CurrentTimeCubit>().current;
                            final format = DateFormat('HH:mm');
                            double nowHeight = 0;
                            if (now.hour < 1){
                              nowHeight = now.minute/60.0*47.0;
                            }else
                              nowHeight = (now.hour-1)*55 + 47.0 + now.minute/60.0*55.0;
                            return Positioned(
                              right: 2.0,
                              top: nowHeight + 2.0,
                              child: Text(format.format(now), style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.w600),),
                            );
                          })
                        ],
                      ),
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
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventAddScreen()),);
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
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
                  child: RowTableDateWidgetBloc()
              );
            });
      })
    );
  }
}