part of '../booking_map_picker_bloc.dart';

class BookingMapPickerState extends Equatable {
  const BookingMapPickerState({
    this.latitude = 0,
    this.longitude = 0,
    this.placeName = Symbols.empty,
    this.address = Symbols.empty,
    this.status = FormzStatus.pure,
  });

  final double latitude;
  final double longitude;
  final String placeName;
  final String address;
  final FormzStatus status;

  BookingMapPickerState copyWith({
    double? latitude,
    double? longitude,
    String? placeName,
    String? address,
    FormzStatus? status,
  }) {
    return BookingMapPickerState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeName: placeName ?? this.placeName,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        latitude,
        longitude,
        placeName,
        address,
        status,
      ];
}
