import 'package:flutter/material.dart';
import 'package:work_manager_app/bloc/date_select_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/extensions.dart';

class DateTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday-1));

    return BlocProvider(
        create: (_) => DateCubit(),
        child: BlocBuilder<DateCubit, DateTime>(builder: (_, state) {
          return Container(
            padding: EdgeInsets.only(top:4, left: 32, right: 16),
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
                                  if (currentDay.isSameDate(now)){
                                    if (state.isSameDate(currentDay)){
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
                                  } else if (state.isSameDate(currentDay)){
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
                                if (currentDay.isSameDate(now)){
                                  if (state.isSameDate(currentDay)){
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
                                } else{
                                  // Case normal day in week is not today
                                  if (state.isSameDate(currentDay)){
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