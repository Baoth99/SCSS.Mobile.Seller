part of '../request_bloc.dart';

abstract class RequestEvent extends AbstractEvent {
  const RequestEvent();
}

class RequestStateInitial extends RequestEvent {}

class RequestAddressPicked extends RequestEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String address;

  const RequestAddressPicked({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
        name,
        address,
      ];
}

class RequestAddressTapped extends RequestEvent {
  final String placeId;
  const RequestAddressTapped(this.placeId);

  @override
  List<String> get props => [placeId];
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
