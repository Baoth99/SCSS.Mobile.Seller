part of '../booking_time_bloc.dart';

class BookingTimeState extends Equatable {
  const BookingTimeState({
    this.date = const BookingDate.pure(),
    this.fromTime = const BookingTime.pure(),
    this.toTime = const BookingTime.pure(),
  });

  final BookingDate date;
  final BookingTime fromTime;
  final BookingTime toTime;

  BookingTimeState copyWith({
    BookingDate? date,
    BookingTime? fromTime,
    BookingTime? toTime,
  }) {
    return BookingTimeState(
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
    );
  }

  @override
  List<Object> get props => [
        date,
        fromTime,
        toTime,
      ];
}
