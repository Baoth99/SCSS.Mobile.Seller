import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/utils/common_utils.dart';

class BookingAddressInfo extends Equatable {
  const BookingAddressInfo({
    this.latitude,
    this.longitude,
    this.name,
    this.address,
  });

  final double? latitude;
  final double? longitude;
  final String? name;
  final String? address;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        name,
        address,
      ];
}

enum BookingAddressError { invalid }

class BookingAddress
    extends FormzInput<BookingAddressInfo, BookingAddressError> {
  const BookingAddress.dirty(
      [BookingAddressInfo value = const BookingAddressInfo()])
      : super.dirty(value);
  const BookingAddress.pure(
      [BookingAddressInfo value = const BookingAddressInfo()])
      : super.pure(value);

  bool _validate(BookingAddressInfo value) {
    return (value.latitude != null &&
        value.longitude != null &&
        (value.name?.isNotEmpty ?? false) &&
        (value.address?.isNotEmpty ?? false));
  }

  @override
  BookingAddressError? validator(BookingAddressInfo value) {
    return _validate(value) ? null : BookingAddressError.invalid;
  }
}

enum BookingTimeError { invalid, lessThanNow }

class BookingTime extends FormzInput<TimeOfDay?, BookingTimeError> {
  const BookingTime.pure([TimeOfDay? value]) : super.pure(value);
  const BookingTime.dirty([TimeOfDay? value]) : super.dirty(value);

  BookingTimeError? _validate(TimeOfDay? value) {
    if (value == null) {
      return BookingTimeError.invalid;
    }

    if (CommonUtils.compareTwoTimeOfDays(value, TimeOfDay.now()) <= 0) {
      return BookingTimeError.lessThanNow;
    }

    return null;
  }

  @override
  BookingTimeError? validator(TimeOfDay? value) {
    return _validate(value);
  }
}

enum BookingDateError { invalid }

class BookingDate extends FormzInput<DateTime?, BookingDateError> {
  const BookingDate.pure([DateTime? value]) : super.pure(value);
  const BookingDate.dirty([DateTime? value]) : super.dirty(value);

  bool _validate(DateTime? value) {
    if (value == null) {
      return false;
    }
    final todayDateTime = DateTime.now();
    final today = DateTime(
      todayDateTime.year,
      todayDateTime.month,
      todayDateTime.day,
    );

    return value.compareTo(today) >= 0;
  }

  @override
  BookingDateError? validator(DateTime? value) {
    return _validate(value) ? null : BookingDateError.invalid;
  }
}
