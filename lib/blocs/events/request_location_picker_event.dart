part of '../request_location_picker_bloc.dart';

abstract class RequestLocationPickerEvent extends AbstractEvent {
  const RequestLocationPickerEvent();
}

class RequestLocationPickerSearchChanged extends RequestLocationPickerEvent {
  const RequestLocationPickerSearchChanged(
    this.searchValue,
  );

  final String searchValue;

  @override
  List<String> get props => [
        searchValue,
      ];
}

class RemovePersonalLocation extends RequestLocationPickerEvent {
  const RemovePersonalLocation(
    this.id,
  );

  final String id;

  @override
  List<String> get props => [
        id,
      ];
}

class RefreshRemoveLocationStatus extends RequestLocationPickerEvent {}
