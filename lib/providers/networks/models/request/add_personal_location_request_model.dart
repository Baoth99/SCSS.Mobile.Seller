import 'dart:convert';

String addPersonalLocationRequestModelToJson(
        AddPersonalLocationRequestModel data) =>
    json.encode(data.toJson());

class AddPersonalLocationRequestModel {
  AddPersonalLocationRequestModel({
    required this.placeId,
    required this.placeName,
    required this.addressName,
    required this.address,
    required this.latitude,
    required this.longtitude,
    required this.district,
    required this.city,
  });

  final String placeId;
  final String placeName;
  final String addressName;
  final String address;
  final double latitude;
  final double longtitude;
  final String district;
  final String city;

  Map<String, dynamic> toJson() => {
        "placeId": placeId,
        "placeName": placeName,
        "addressName": addressName,
        "address": address,
        "latitude": latitude,
        "longtitude": longtitude,
        "district": district,
        "city": city,
      };
}
