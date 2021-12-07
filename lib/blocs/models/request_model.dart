import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/utils/common_utils.dart';

class RequestAddressInfo extends Equatable {
  const RequestAddressInfo({
    this.placeId,
    this.latitude,
    this.longitude,
    this.name,
    this.address,
    this.district,
    this.city,
  });

  final String? placeId;
  final double? latitude;
  final double? longitude;
  final String? name;
  final String? address;
  final String? district;
  final String? city;

  @override
  List<Object?> get props => [
        placeId,
        latitude,
        longitude,
        name,
        address,
        district,
        city,
      ];
}

enum RequestAddressError { invalid }

class RequestAddress
    extends FormzInput<RequestAddressInfo, RequestAddressError> {
  const RequestAddress.dirty(
      [RequestAddressInfo value = const RequestAddressInfo()])
      : super.dirty(value);
  const RequestAddress.pure(
      [RequestAddressInfo value = const RequestAddressInfo()])
      : super.pure(value);

  bool _validate(RequestAddressInfo value) {
    return (value.latitude != null &&
        value.longitude != null &&
        (value.name?.isNotEmpty ?? false) &&
        (value.address?.isNotEmpty ?? false) &&
        (value.district?.isNotEmpty ?? false) &&
        (value.city?.isNotEmpty ?? false));
  }

  @override
  RequestAddressError? validator(RequestAddressInfo value) {
    return _validate(value) ? null : RequestAddressError.invalid;
  }
}

enum RequestTimeError { invalid, lessThanNow }

class RequestTime extends FormzInput<TimeOfDay?, RequestTimeError> {
  const RequestTime.pure([TimeOfDay? value]) : super.pure(value);
  const RequestTime.dirty([TimeOfDay? value]) : super.dirty(value);

  RequestTimeError? _validate(TimeOfDay? value) {
    if (value == null) {
      return RequestTimeError.invalid;
    }

    if (CommonUtils.compareTwoTimeOfDays(value, TimeOfDay.now()) <= 0) {
      return RequestTimeError.lessThanNow;
    }

    return null;
  }

  @override
  RequestTimeError? validator(TimeOfDay? value) {
    return _validate(value);
  }
}

enum RequestDateError { invalid }

class RequestDate extends FormzInput<DateTime?, RequestDateError> {
  const RequestDate.pure([DateTime? value]) : super.pure(value);
  const RequestDate.dirty([DateTime? value]) : super.dirty(value);

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
  RequestDateError? validator(DateTime? value) {
    return _validate(value) ? null : RequestDateError.invalid;
  }
}
