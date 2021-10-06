import 'package:flutter/material.dart';
import 'package:seller_app/utils/common_utils.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime onlyDate() {
    return DateTime(year, month, day);
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
