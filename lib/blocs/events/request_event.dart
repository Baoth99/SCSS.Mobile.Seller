part of '../request_bloc.dart';

abstract class RequestEvent extends AbstractEvent {
  const RequestEvent();
}

class RequestStateInitial extends RequestEvent {}

class RequestAddressPicked extends RequestEvent {
  final String placeId;
  final double latitude;
  final double longitude;
  final String name;
  final String address;
  final String district;
  final String city;

  const RequestAddressPicked({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
    required this.district,
    required this.city,
  });

  @override
  List<Object> get props => [
        placeId,
        latitude,
        longitude,
        name,
        address,
        district,
        city,
      ];
}

class RequestAddressTapped extends RequestEvent {
  final String placeId;
  final String district;
  final String city;
  const RequestAddressTapped(
    this.placeId,
    this.district,
    this.city,
  );

  @override
  List<String> get props => [
        placeId,
        district,
        city,
      ];
}

class RequestTimePicked extends RequestEvent {
  const RequestTimePicked({
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

class RequestNoteChanged extends RequestEvent {
  const RequestNoteChanged(this.value);

  final String value;

  @override
  List<String> get props => [value];
}

class RequestBulkyChosen extends RequestEvent {
  final YesNo value;

  const RequestBulkyChosen(this.value);

  @override
  List<YesNo> get props => [value];
}

class RequestImageAdded extends RequestEvent {
  final File image;
  const RequestImageAdded(this.image);

  @override
  List<File> get props => [image];
}

class RequestImageDeleted extends RequestEvent {}

class RequestAddressInitial extends RequestEvent {}

class RequestSummited extends RequestEvent {}

class PersonalLocationGet extends RequestEvent {}

class CheckPersonalLocation extends RequestEvent {}

class RefreshCheckPersonalLocation extends RequestEvent {}

class AddPersonalLocation extends RequestEvent {
  final String placeName;

  const AddPersonalLocation(this.placeName);

  @override
  List<String> get props => [placeName];
}
