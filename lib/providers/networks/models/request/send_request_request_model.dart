import 'package:flutter/material.dart';
import 'package:seller_app/utils/common_utils.dart';

class SendRequestRequestModel {
  SendRequestRequestModel({
    required this.addressName,
    required this.address,
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
        "latitude": latitude,
        "longtitude": longtitude,
        "collectingRequestDate": collectingRequestDate.toIso8601String(),
        "fromTime": CommonUtils.convertTimeToString(fromTime),
        "toTime": CommonUtils.convertTimeToString(toTime),
        "note": note,
        "isBulky": isBulky,
        "collectingRequestImageUrl": collectingRequestImageUrl,
      };
}
