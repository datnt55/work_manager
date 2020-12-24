
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }
}

extension DateDifferentMidNight on DateTime {
  Duration differenceMidNight(DateTime other) {
    final midNightStart = new DateTime(this.year, this.month, this.day);
    final midNightEnd = new DateTime(other.year, other.month, other.day);
    return midNightStart.difference(midNightEnd);

  }
}

extension MyDateUtils on DateTime {
  DateTime copyWith(
      {int year,
        int month,
        int day,
        int hour,
        int minute,
        int second,
        int millisecond,
        int microsecond}) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}