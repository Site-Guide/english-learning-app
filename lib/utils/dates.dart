class Dates {
  static DateTime get now => DateTime.now();
  static DateTime get today => DateTime(now.year, now.month, now.day);
  static DateTime get tommorow => today.add(const Duration(days: 1));
}