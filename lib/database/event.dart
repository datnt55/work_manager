import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Event extends Equatable{
  int id;
  String title;
  int fromDate;
  int endDate;
  int color;


  Event(this.title, this.fromDate, this.endDate, this.color);

  @override
  // TODO: implement props
  List<Object> get props => [title, fromDate, endDate];

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fromDate = json['start'];
    endDate = json['end'];
    color = json['color'];
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>()
      ..["title"] = title
      ..["start"] = fromDate
      ..["end"] = endDate
      ..["color"] = color;
  }
}