part of '../booking_bloc.dart';

class BookingState extends Equatable {
  const BookingState({
    this.address = const BookingAddress.pure(),
    this.date,
    this.fromTime,
    this.toTime,
    this.note = Symbols.empty,
    this.bulky = YesNo.no,
    required this.imageFile,
    this.status = FormzStatus.pure,
  });

  final BookingAddress address;
  final DateTime? date;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final String note;
  final YesNo bulky;
  final File imageFile;
  final FormzStatus status;

  BookingState copyWith(
      {BookingAddress? address,
      DateTime? date,
      TimeOfDay? fromTime,
      TimeOfDay? toTime,
      String? note,
      YesNo? bulky,
      File? imageFile,
      FormzStatus? status}) {
    return BookingState(
      address: address ?? this.address,
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      note: note ?? this.note,
      bulky: bulky ?? this.bulky,
      imageFile: imageFile ?? this.imageFile,
      status: status ?? this.status,
    );
  }

  BookingState refresh() {
    return BookingState(
      imageFile: Others.emptyFile,
    );
  }

  @override
  List<Object?> get props => [
        address,
        date,
        fromTime,
        toTime,
        note,
        bulky,
        imageFile,
        status,
      ];
}
