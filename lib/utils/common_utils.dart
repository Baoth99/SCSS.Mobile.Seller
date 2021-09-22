import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';

class CommonUtils {
  static String toStringPadleft(int number, int width) {
    return number.toString().padLeft(width, '0');
  }

  static String concatString(List<String> strs,
      [String seperator = Symbols.space]) {
    return strs.join(seperator);
  }

  static DateTime getNearDateTime(int minuteInterval) {
    var now = DateTime.now();
    var nowMinute = now.minute;
    var dividedNumber = nowMinute ~/ minuteInterval;

    var minuteAdded = dividedNumber * minuteInterval + minuteInterval * 2;

    final result = DateTime(now.year, now.month, now.day, now.hour, 0).add(
      Duration(minutes: minuteAdded),
    );
    return result;
  }

  static int compareTwoTimeOfDays(TimeOfDay time1, TimeOfDay time2) {
    return convertTimeOfDayToDouble(time1).compareTo(
      convertTimeOfDayToDouble(time2),
    );
  }

  static double convertTimeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / TimeOfDay.minutesPerHour;
  }

  static String combineDateToTime(
      DateTime date, String fromtime, String totime) {
    String strDate = convertDateTimeToVietnamese(date);
    return '$strDate${Symbols.comma} $fromtime ${Symbols.minus} $totime';
  }

  static String convertDateTimeToVietnamese(DateTime? date) {
    if (date == null) return Symbols.empty;

    //today
    final now = DateTime.now();

    // today and tomorrow
    if (now.year == date.year && now.month == date.month) {
      if (now.day == date.day) {
        return VietnameseDate.today;
      } else if (date.day - now.day == 1) {
        return VietnameseDate.tomorrow;
      }
    }

    var weekday = VietnameseDate.weekdayMap[date.weekday];
    var result = VietnameseDate.pattern
        .replaceFirst(VietnameseDate.weekdayParam, weekday ?? Symbols.empty)
        .replaceFirst(VietnameseDate.dayParam, date.day.toString())
        .replaceFirst(VietnameseDate.monthParam, date.month.toString());
    return result;
  }

  static TimeOfDay addTimeOfDay(TimeOfDay time, int minute) {
    double doubleTime = time.hour + time.minute / 60 + minute / 60;
    int h = doubleTime.truncate();
    int m = ((doubleTime - doubleTime.truncate()) * 60).toInt();

    return TimeOfDay(hour: h, minute: m);
  }
}

class CommonTest {
  static Future<void> delay() async {
    return await Future<void>.delayed(
      const Duration(
        seconds: 2,
      ),
    );
  }
}
