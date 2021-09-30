part of '../booking_time_bloc.dart';

class BookingTimeEvent extends AbstractEvent {
  const BookingTimeEvent();
}

class BookingTimeDatePicked extends BookingTimeEvent {
  const BookingTimeDatePicked(this.date);

  final DateTime date;

  @override
  List<DateTime> get props => [date];
}

class BookingTimeInitial extends BookingTimeEvent {}

class BookingTimeTimeFromPicked extends BookingTimeEvent {
  const BookingTimeTimeFromPicked(this.time);

  final DateTime time;

  @override
  List<DateTime> get props => [time];
}

class BookingTimeTimeToPicked extends BookingTimeEvent {
  const BookingTimeTimeToPicked(this.time);

  final DateTime time;

  @override
  List<DateTime> get props => [time];
}
