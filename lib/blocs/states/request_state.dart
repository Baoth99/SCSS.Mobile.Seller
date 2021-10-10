part of '../request_bloc.dart';

class RequestState extends Equatable {
  const RequestState({
    this.address = const RequestAddress.pure(),
    this.date,
    this.fromTime,
    this.toTime,
    this.note = Symbols.empty,
    this.bulky = YesNo.no,
    required this.imageFile,
    this.status = FormzStatus.pure,
    this.errorCode = Symbols.empty,
    this.requestId = Symbols.empty,
  });

  final RequestAddress address;
  final DateTime? date;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;
  final String note;
  final YesNo bulky;
  final File imageFile;
  final FormzStatus status;
  final String errorCode;
  final String requestId;

  RequestState copyWith({
    RequestAddress? address,
    DateTime? date,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
    String? note,
    YesNo? bulky,
    File? imageFile,
    FormzStatus? status,
    String? errorCode,
    String? requestId,
  }) {
    return RequestState(
      address: address ?? this.address,
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      note: note ?? this.note,
      bulky: bulky ?? this.bulky,
      imageFile: imageFile ?? this.imageFile,
      status: status ?? this.status,
      errorCode: errorCode ?? this.errorCode,
      requestId: requestId ?? this.requestId,
    );
  }

  RequestState refresh() {
    return RequestState(
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
        errorCode,
        requestId,
      ];
}
