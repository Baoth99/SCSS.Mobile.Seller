part of '../request_map_picker_bloc.dart';

class RequestMapPickerState extends Equatable {
  const RequestMapPickerState({
    this.placeId = Symbols.empty,
    this.latitude = 0,
    this.longitude = 0,
    this.placeName = Symbols.empty,
    this.address = Symbols.empty,
    this.district = Symbols.empty,
    this.city = Symbols.empty,
    this.status = FormzStatus.pure,
  });
  final String placeId;
  final double latitude;
  final double longitude;
  final String placeName;
  final String address;
  final String district;
  final String city;
  final FormzStatus status;

  RequestMapPickerState copyWith({
    String? placeId,
    double? latitude,
    double? longitude,
    String? placeName,
    String? address,
    String? district,
    String? city,
    FormzStatus? status,
  }) {
    return RequestMapPickerState(
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeName: placeName ?? this.placeName,
      address: address ?? this.address,
      district: district ?? this.district,
      city: city ?? this.city,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        placeId,
        latitude,
        longitude,
        placeName,
        address,
        district,
        city,
        status,
      ];
}
