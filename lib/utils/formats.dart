// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formats {
  static String monthDay(DateTime date) =>
      DateFormat(DateFormat.MONTH_DAY).format(date);

  static String monthDayTime(DateTime date) =>
      DateFormat("MMM d hh:mm a").format(date);
  static String time(DateTime date) => DateFormat("hh:mm a").format(date);
  static String date(DateTime date) => DateFormat("dd-MM-yyyy").format(date);
  static String month(DateTime date) =>
      DateFormat(DateFormat.YEAR_MONTH).format(date);

  static String monthDayFromDate(String date) => monthDay(dateTime(date));

  static DateTime dateTime(String date) => DateFormat("dd-MM-yyyy").parse(date);

  static String weekD(DateTime dateTime) {
    return DateFormat(DateFormat.WEEKDAY).format(dateTime).split('').first;
  }

  static String duration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    if (int.parse(twoDigits(duration.inDays)) != 0) {
      return "${twoDigits(duration.inDays)}d:${twoDigitHours}h";
    } else {
      return "${twoDigitHours}h:${twoDigitMinutes}m";
    }
  }
}

extension Format on DateTime {
  String get monthDay => DateFormat(DateFormat.MONTH_DAY).format(this);

  String get monthDaySimple => DateFormat("d MMM").format(this);


  String get monthLabel => DateFormat("MMM").format(this);

  String get time => DateFormat("hh:mm a").format(this);
  String get time2 => DateFormat("hh:mma").format(this);

  String get date => DateFormat('d-MM-yy').format(this);

  DateTime setTime(TimeOfDay timeOfDay) => DateTime(
        year,
        month,
        day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
}
