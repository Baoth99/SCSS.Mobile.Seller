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
        date,
        fromTime,
        toTime,
      ];
}

class BookingNoteChanged extends BookingEvent {
  const BookingNoteChanged(this.value);

  final String value;

  @override
  List<String> get props => [value];
}

class BookingBulkyChosen extends BookingEvent {
  final YesNo value;

  const BookingBulkyChosen(this.value);

  @override
  List<YesNo> get props => [value];
}

class BookingImageAdded extends BookingEvent {
  final String path;
  const BookingImageAdded(this.path);

  @override
  List<String> get props => [path];
}

class BookingImageDeleted extends BookingEvent {}
