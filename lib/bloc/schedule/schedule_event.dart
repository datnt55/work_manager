part of 'scheldule_bloc.dart';

@immutable
class SaveSchedule extends BaseEvent{
  final Event event;

  SaveSchedule(this.event);

}

class FetchSchedule extends BaseEvent{}