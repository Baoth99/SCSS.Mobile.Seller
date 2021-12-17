import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

OperatingTimeResponseModel operatingTimeResponseModelFromJson(String str) =>
    OperatingTimeResponseModel.fromJson(json.decode(str));

class OperatingTimeResponseModel extends BaseResponseModel {
  OperatingTimeResponseModel({
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

  factory OperatingTimeResponseModel.fromJson(Map<String, dynamic> json) =>
      OperatingTimeResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: ResData.fromJson(json["resData"]),
      );
}

class ResData {
  ResData({
    required this.operatingFromTime,
    required this.operatingToTime,
  });

  String operatingFromTime;
  String operatingToTime;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        operatingFromTime: json["operatingFromTime"],
        operatingToTime: json["operatingToTime"],
      );
}
