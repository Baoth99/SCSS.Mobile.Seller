import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:intl/intl.dart' show NumberFormat;

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

  String toVietnameseStringNotYear() {
    String dayOfWeek = VietnameseDate.weekdayMap[weekday] ?? Symbols.empty;
    return '$dayOfWeek, ${day.toStringLeadingTwoZero()} thg $month';
  }

  String toVietnameseStringNotYearHaveTime() {
    return '${toVietnameseStringNotYear()}, ${hour.toStringLeadingTwoZero()}:${minute.toStringLeadingTwoZero()}';
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

  String toStringAndRemoveFractionalIfCan() {
    var value = toInt();
    if (value == this) {
      return value.toString();
    }
    return toString();
  }
}

extension DynamicExtension on dynamic {
  double? toDoubleOrNull() {
    if (this == null) {
      return null;
    }

    try {
      return this.toDouble();
    } catch (e) {
      return null;
    }
  }
}

extension IntegerExtension on int {
  String toStringLeadingTwoZero() {
    return toString().padLeft(2, '0');
  }

  String toAppPrice() {
    var f = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return f.format(this);
  }
}
