// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocoding_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseGeocodingResponseModel _$ReverseGeocodingResponseModelFromJson(
    Map<String, dynamic> json) {
  return ReverseGeocodingResponseModel(
    results: ((json['results'] ?? []) as List<dynamic>?)
        ?.map((e) => _Result.fromJson(e as Map<String, dynamic>))
        .toList(),
    status: json['status'] as String,
  );
}

_Result _$_ResultFromJson(Map<String, dynamic> json) {
  return _Result(
    addressComponents: (json['address_components'] as List<dynamic>?)
        ?.map((e) => _AddressComponent.fromJson(e as Map<String, dynamic>))
        .toList(),
    placeId: json['place_id'] as String?,
  );
}

_AddressComponent _$_AddressComponentFromJson(Map<String, dynamic> json) {
  return _AddressComponent(
    longName: json['long_name'] as String,
    shortName: json['short_name'] as String,
  );
}
