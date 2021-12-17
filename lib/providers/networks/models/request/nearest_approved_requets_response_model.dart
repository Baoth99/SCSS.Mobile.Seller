import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

NearestApprovedRequestResponseModel nearestApprovedRequestResponseModelFromJson(
        String str) =>
    NearestApprovedRequestResponseModel.fromJson(json.decode(str));

class NearestApprovedRequestResponseModel extends BaseResponseModel {
  NearestApprovedRequestResponseModel({
    required bool isSuccess,
    required int statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    this.resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        );

  dynamic msgCode;
  dynamic msgDetail;
  dynamic total;
  ResData? resData;

  factory NearestApprovedRequestResponseModel.fromJson(
          Map<String, dynamic> json) =>
      NearestApprovedRequestResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData:
            json["resData"] != null ? ResData.fromJson(json["resData"]) : null,
      );
}

class ResData {
  ResData({
    required this.collectingRequestId,
    required this.collectingRequestCode,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.addressName,
    required this.address,
    required this.isBulky,
    required this.status,
  });

  String collectingRequestId;
  String collectingRequestCode;
  DateTime collectingRequestDate;
  String fromTime;
  String toTime;
  String addressName;
  String address;
  bool isBulky;
  int status;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        collectingRequestId: json["collectingRequestId"],
        collectingRequestCode: json["collectingRequestCode"],
        collectingRequestDate: DateTime.parse(json["collectingRequestDate"]),
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        addressName: json["addressName"],
        address: json["address"],
        isBulky: json["isBulky"],
        status: json["status"],
      );
}
