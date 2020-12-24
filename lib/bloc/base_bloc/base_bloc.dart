import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_manager_app/bloc/base_bloc/base_event.dart';
import 'package:work_manager_app/bloc/base_bloc/base_state.dart';

abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {

  BaseBloc(BaseState initialState) : super(initialState);

  @override
  BaseState get initialState => InitState();


}
