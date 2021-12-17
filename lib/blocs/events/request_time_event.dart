part of '../request_time_bloc.dart';

class RequestTimeEvent extends AbstractEvent {
  const RequestTimeEvent();
}

class RequestTimeDatePicked extends RequestTimeEvent {
  const RequestTimeDatePicked(this.date);

  final DateTime date;

  @override
  List<DateTime> get props => [date];
}

class RequestTimeInitial extends RequestTimeEvent {}

class RequestTimeTimeFromPicked extends RequestTimeEvent {
  const RequestTimeTimeFromPicked(this.time);

  final DateTime time;

  @override
  List<DateTime> get props => [time];
}

class RequestTimeTimeToPicked extends RequestTimeEvent {
  const RequestTimeTimeToPicked(this.time);

  final DateTime time;

  @override
  List<DateTime> get props => [time];
}
