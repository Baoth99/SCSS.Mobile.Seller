// To parse this JSON data, do
//
//     final personalLocationGetResponseModel = personalLocationGetResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

PersonalLocationGetResponseModel personalLocationGetResponseModelFromJson(
        String str) =>
    PersonalLocationGetResponseModel.fromJson(json.decode(str));

class PersonalLocationGetResponseModel extends BaseResponseModel {
  PersonalLocationGetResponseModel({
    bool? isSuccess,
    int? statusCode,
    this.msgCode,
    this.msgDetail,
    required this.total,
    required this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  final int total;
  final List<ResDatum> resData;

  factory PersonalLocationGetResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PersonalLocationGetResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<ResDatum>.from(
            json["resData"].map((x) => ResDatum.fromJson(x))),
      );
}

class ResDatum {
  ResDatum({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.addressName,
    required this.address,
    required this.latitude,
    required this.longtitude,
    required this.district,
    required this.city,
  });

  final String id;
  final String placeId;
  final String placeName;
  final String addressName;
  final String address;
  final double latitude;
  final double longtitude;
  final String district;
  final String city;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        id: json["id"],
        placeId: json["placeId"],
        placeName: json["placeName"],
        addressName: json["addressName"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        district: json["district"],
        city: json["city"],
      );
}
