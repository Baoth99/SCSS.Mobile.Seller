part of '../booking_bloc.dart';

abstract class BookingEvent extends AbstractEvent {
  const BookingEvent();
}

class BookingStateInitial extends BookingEvent {}

class BookingAddressPicked extends BookingEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String address;

  const BookingAddressPicked({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
        name,
        address,
      ];
}

class BookingAddressTapped extends BookingEvent {
  final String placeId;
  const BookingAddressTapped(this.placeId);

  @override
  List<String> get props => [placeId];
}

class BookingTimePicked extends BookingEvent {
  const BookingTimePicked({
    required this.date,
    required this.fromTime,
    required this.toTime,
  });

  final DateTime date;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;

  @override
  List<Object> get props => [
        this.date,
        this.fromTime,
        this.toTime,
      ];
}
