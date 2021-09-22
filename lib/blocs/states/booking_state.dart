part of '../booking_bloc.dart';

class BookingState extends Equatable {
  const BookingState({
    this.address = const BookingAddress.pure(),
    this.date = const BookingDate.pure(),
    this.fromTime = const BookingTime.pure(),
    this.toTime = const BookingTime.pure(),
    this.note = Symbols.empty,
    this.bulky = YesNo.no,
    this.imagePath = Symbols.empty,
    this.status = FormzStatus.pure,
  });

  final BookingAddress address;
  final BookingDate date;
  final BookingTime fromTime;
  final BookingTime toTime;
  final String note;
  final YesNo bulky;
  final String imagePath;
  final FormzStatus status;

  BookingState copyWith(
      {BookingAddress? address,
      BookingDate? date,
      BookingTime? fromTime,
      BookingTime? toTime,
      String? note,
      YesNo? bulky,
      String? imagePath,
      FormzStatus? status}) {
    return BookingState(
      address: address ?? this.address,
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      note: note ?? this.note,
      bulky: bulky ?? this.bulky,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
    );
  }

  BookingState refresh() {
    return const BookingState();
  }

  @override
  List<Object> get props => [
        address,
        date,
        fromTime,
        toTime,
        note,
        bulky,
        imagePath,
        status,
      ];
}
