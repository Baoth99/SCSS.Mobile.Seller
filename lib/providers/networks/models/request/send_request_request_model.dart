import 'package:flutter/material.dart';
import 'package:seller_app/utils/extension_methods.dart';

class SendRequestRequestModel {
  SendRequestRequestModel({
    required this.addressName,
    required this.address,
    required this.district,
    required this.city,
    required this.latitude,
    required this.longtitude,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.note,
    required this.isBulky,
    this.collectingRequestImageUrl,
  });

  String addressName;
  String address;
  String district;
  String city;
  double latitude;
  double longtitude;
  DateTime collectingRequestDate;
  TimeOfDay fromTime;
  TimeOfDay toTime;
  String note;

  bool isBulky;
  String? collectingRequestImageUrl;

  Map<String, dynamic> toJson() => {
        "addressName": addressName,
        "address": address,
        "district": district,
        "city": city,
        "latitude": latitude,
        "longtitude": longtitude,
        "collectingRequestDate": collectingRequestDate.toDateString(),
        "fromTime": fromTime.toFullString(),
        "toTime": toTime.toFullString(),
        "note": note,
        "isBulky": isBulky,
        "collectingRequestImageUrl": collectingRequestImageUrl,
      };
}
