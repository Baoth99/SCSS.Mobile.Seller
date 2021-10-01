part of '../request_map_picker_bloc.dart';

abstract class RequestMapPickerEvent {
  const RequestMapPickerEvent();
}

class RequestMapPickerMapChanged extends RequestMapPickerEvent {
  const RequestMapPickerMapChanged(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  List<double> get props => [
        latitude,
        longitude,
      ];
}

class RequestMapPickerMapInitial extends RequestMapPickerEvent {}
