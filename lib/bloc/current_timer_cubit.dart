import 'dart:async';

import 'package:bloc/bloc.dart';

class CurrentTimeCubit extends Cubit<DateTime> {
  var current = DateTime.now();
  CurrentTimeCubit() : super(DateTime.now()){
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
        oneSec, (Timer timer) {
          if (DateTime.now().minute != current.minute) {
            current = DateTime.now();
            emit(current);
          }
        }
    );
  }

}

