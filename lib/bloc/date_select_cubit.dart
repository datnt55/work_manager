import 'package:bloc/bloc.dart';

class DateCubit extends Cubit<DateTime> {
  DateCubit() : super(DateTime.now());

  void setCurrentDate(DateTime dateTime){
    emit(dateTime);
  }
}
