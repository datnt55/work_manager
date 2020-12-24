import 'package:equatable/equatable.dart';
abstract class ResponseState<T> extends Equatable{}

class InitialState<T> extends ResponseState<T> {
  @override
  List<Object> get props => [];
}

class LoadingState<T> extends ResponseState<T> {
  @override
  List<Object> get props => [];

}

class SuccessState<T> extends ResponseState<T> {

  SuccessState(this.response);

  final T response;

  @override
  List<T> get props => [response];
}

class ErrorState<T> extends ResponseState<T> {
  @override
  List<Object> get props => [];
}

