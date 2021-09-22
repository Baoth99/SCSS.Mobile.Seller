import 'package:json_annotation/json_annotation.dart';

part 'reverse_geocoding_response_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ReverseGeocodingResponseModel {
  ReverseGeocodingResponseModel({
    this.results,
    required this.status,
  });

  final List<_Result>? results;
  final String status;

  factory ReverseGeocodingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodingResponseModelFromJson(json);
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class _Result {
  _Result({this.addressComponents, this.placeId});

  final List<_AddressComponent>? addressComponents;
  final String? placeId;

  factory _Result.fromJson(Map<String, dynamic> json) =>
      _$_ResultFromJson(json);
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class _AddressComponent {
  _AddressComponent({required this.longName, required this.shortName});

  final String longName;
  final String shortName;

  factory _AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$_AddressComponentFromJson(json);
}
