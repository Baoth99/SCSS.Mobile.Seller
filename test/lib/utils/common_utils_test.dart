import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:test/test.dart';

void main() {
  group('addTimeOfDay', () {
    test('15', () {
      var matcher = TimeOfDay(hour: 20, minute: 29);

      var actual =
          CommonUtils.addTimeOfDay(TimeOfDay(hour: 20, minute: 14), 15);
      expect(actual, matcher);
    });

    test('45', () {
      var matcher = TimeOfDay(hour: 20, minute: 00);

      var actual =
          CommonUtils.addTimeOfDay(TimeOfDay(hour: 19, minute: 15), 45);
      expect(actual, matcher);
    });
  });

  group('compareTwoTimeOfDays', () {
    test('equal', () {
      var time1 = const TimeOfDay(hour: 15, minute: 55);
      var time2 = const TimeOfDay(hour: 15, minute: 55);

      var actual = CommonUtils.compareTwoTimeOfDays(time1, time2);

      expect(actual, 0);
    });

    test('large', () {
      var time1 = const TimeOfDay(hour: 12, minute: 33);
      var time2 = const TimeOfDay(hour: 10, minute: 55);

      var actual = CommonUtils.compareTwoTimeOfDays(time1, time2);

      expect(actual, 1);
    });

    test('less', () {
      var time1 = const TimeOfDay(hour: 10, minute: 60);
      var time2 = const TimeOfDay(hour: 15, minute: 55);

      var actual = CommonUtils.compareTwoTimeOfDays(time1, time2);

      expect(actual, -1);
    });
  });
  group('convertDateTimeToVietnamese', () {
    test('Null', () {
      var actual = CommonUtils.convertDateTimeToVietnamese(null);
      expect(actual, Symbols.empty);
    });

    test('now', () {
      var actual = CommonUtils.convertDateTimeToVietnamese(DateTime.now());
      expect(actual, 'Hôm nay');
    });

    test('tomorrow', () {
      var now = DateTime.now();

      var actual = CommonUtils.convertDateTimeToVietnamese(
        now.add(
          const Duration(days: 1),
        ),
      );

      expect(actual, 'Ngày mai');
    });

    test('Th 2', () {
      var date = DateTime(2021, 9, 13);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 2, 13 thg 9');
    });

    test('Th 3', () {
      var date = DateTime(2021, 9, 14);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 3, 14 thg 9');
    });

    test('Th 4', () {
      var date = DateTime(2021, 9, 15);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 4, 15 thg 9');
    });

    test('Th 5', () {
      var date = DateTime(2021, 9, 16);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 5, 16 thg 9');
    });

    test('Th 6', () {
      var date = DateTime(2021, 9, 17);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 6, 17 thg 9');
    });

    test('Th 7', () {
      var date = DateTime(2021, 9, 18);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'Th 7, 18 thg 9');
    });

    test('CN', () {
      var date = DateTime(2021, 9, 19);
      var actual = CommonUtils.convertDateTimeToVietnamese(date);

      expect(actual, 'CN, 19 thg 9');
    });
  });
}
