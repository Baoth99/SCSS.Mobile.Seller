part of '../booking_map_picker_bloc.dart';

abstract class BookingMapPickerEvent {
  const BookingMapPickerEvent();
}

class BookingMapPickerMapChanged extends BookingMapPickerEvent {
  const BookingMapPickerMapChanged(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  List<double> get props => [
        latitude,
        longitude,
      ];
}

class BookingMapPickerMapInitial extends BookingMapPickerEvent {}
