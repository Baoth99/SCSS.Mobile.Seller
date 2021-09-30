part of '../booking_time_bloc.dart';

class BookingTimeState extends Equatable {
  const BookingTimeState({
    required this.date,
    required this.fromTime,
    required this.toTime,
    this.chosableDates = const [],
    this.status = BookingTimeStatus.pure,
    this.blocStatus = FormzStatus.pure,
  });

  final DateTime date;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;
  final List<DateTime> chosableDates;
  final BookingTimeStatus status;
  final FormzStatus blocStatus;

  BookingTimeState copyWith({
    DateTime? date,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
    List<DateTime>? chosableDates,
    BookingTimeStatus? status,
    FormzStatus? blocStatus,
  }) {
    return BookingTimeState(
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
