
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formats {
  static TimeOfDay parseTime(String v) => TimeOfDay.fromDateTime(DateFormat('hh:mm a').parse(v));
}

extension FormatTime on TimeOfDay {
  String get label => DateFormat('hh:mm a').format(DateTime(0, 0, 0, hour, minute));
}