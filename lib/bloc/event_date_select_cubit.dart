import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class DateEventCubit extends Cubit<DateTime> {
  DateEventCubit() : super(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 1, 0 ,0));

  DateTime current;
  void setCurrentDate(DateTime dateTime){
    this.current = dateTime;
    emit(current);
  }
}
