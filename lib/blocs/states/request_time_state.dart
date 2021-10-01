part of '../request_time_bloc.dart';

class RequestTimeState extends Equatable {
  const RequestTimeState({
    required this.date,
    required this.fromTime,
    required this.toTime,
    this.chosableDates = const [],
    this.status = RequestTimeStatus.pure,
    this.blocStatus = FormzStatus.pure,
  });

  final DateTime date;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;
  final List<DateTime> chosableDates;
  final RequestTimeStatus status;
  final FormzStatus blocStatus;

  RequestTimeState copyWith({
    DateTime? date,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
    List<DateTime>? chosableDates,
    RequestTimeStatus? status,
    FormzStatus? blocStatus,
  }) {
    return RequestTimeState(
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      chosableDates: chosableDates ?? this.chosableDates,
      status: status ?? this.status,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  List<Object> get props => [
        date,
        fromTime,
        toTime,
        chosableDates,
        status,
        blocStatus,
      ];
}
