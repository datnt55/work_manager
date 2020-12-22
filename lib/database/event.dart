import 'package:equatable/equatable.dart';

class Event extends Equatable{
  String title;
  int fromDate;
  int endDate;

  @override
  // TODO: implement props
  List<Object> get props => [title, fromDate, endDate];

  Event.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fromDate = json['fromDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>()
      ..["title"] = title
      ..["fromDate"] = fromDate
      ..["endDate"] = endDate;
  }
}