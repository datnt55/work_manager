import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class DateEventCubit extends Cubit<DateTime> {
  DateEventCubit() : super(DateTime.now());

  void setCurrentDate(DateTime dateTime){
    emit(dateTime);
  }
}
