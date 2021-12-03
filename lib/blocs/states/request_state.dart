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
    this.personalLocations = const [],
    this.personalLocationStatus = FormzStatus.pure,
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
  final List<PersonalLocation> personalLocations;
  final FormzStatus personalLocationStatus;

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
    List<PersonalLocation>? personalLocations,
    FormzStatus? personalLocationStatus,
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
      personalLocations: personalLocations ?? this.personalLocations,
      personalLocationStatus:
          personalLocationStatus ?? this.personalLocationStatus,
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
        personalLocations,
        personalLocationStatus,
      ];
}

class PersonalLocation extends Equatable {
  const PersonalLocation({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.addressName,
    required this.address,
    required this.latitude,
    required this.longtitude,
    required this.district,
    required this.city,
  });

  final String id;
  final String placeId;
  final String placeName;
  final String addressName;
  final String address;
  final double latitude;
  final double longtitude;
  final String district;
  final String city;

  @override
  List<Object> get props => [
        id,
        placeId,
        placeName,
        addressName,
        address,
        latitude,
        longtitude,
        district,
        city,
      ];
}
