import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:work_manager_app/bloc/base_bloc/base.dart';
import 'package:work_manager_app/database/event.dart';
import 'package:work_manager_app/repository/EventRepository.dart';

import '../../locator.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<BaseEvent, BaseState> {

  final EventRepository repository = locator<EventRepository>();

  ScheduleBloc() : super(InitState());



  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is UpdateSchedule) {
      try {
        yield (LoadingState());
        final result = await repository.updateEvent(event.event);
        yield (UpdateScheduleSuccessState());
      } catch (e) {
        yield (ErrorState(data: e.toString()));
      }
    }else if (event is SaveSchedule) {
      try {
        yield (LoadingState());
        final result = await repository.addFavorite(event.event);
        yield (AddScheduleSuccessState());
      } catch (e) {
        yield (ErrorState(data: e.toString()));
      }
    }else if (event is FetchSchedule) {
      try {
        yield (LoadingState());
        final result = await repository.getEvents();
        yield (LoadedState<List<Event>>(data: result));
      } catch (e) {
        yield (ErrorState(data: e.toString()));
      }
    }

  }
}
