import 'package:flutter/material.dart';
import 'package:seller_app/utils/common_utils.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  String toDateString() {
    return '$year-${CommonUtils.toStringLeadingZero(month, 2)}-${CommonUtils.toStringLeadingZero(day, 2)}';
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String toFullString() {
    return '${CommonUtils.toStringLeadingZero(hour, 2)}:${CommonUtils.toStringLeadingZero(minute, 2)}';
  }
}

extension TimeOfDayCompare on TimeOfDay {
  bool isLargeThan(TimeOfDay time) {
    return CommonUtils.compareTwoTimeOfDays(this, time) > 0;
  }

  bool isLessThan(TimeOfDay time) {
    return CommonUtils.compareTwoTimeOfDays(this, time) < 0;
  }
}

extension DoubleExtension on double {
  String toStringOneFixed() {
    return toStringAsFixed(1);
  }
}
