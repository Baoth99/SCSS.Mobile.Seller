import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

SendRequestResponseModel sendRequestResponseModelFromJson200(String str) =>
    SendRequestResponseModel.fromJson200(json.decode(str));
SendRequestResponseModel sendRequestResponseModelFromJson400(String str) =>
    SendRequestResponseModel.fromJson400(json.decode(str));

class SendRequestResponseModel extends BaseResponseModel {
  SendRequestResponseModel({
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
  dynamic resData;

  factory SendRequestResponseModel.fromJson200(Map<String, dynamic> json) =>
      SendRequestResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"] as String,
      );

  factory SendRequestResponseModel.fromJson400(Map<String, dynamic> json) =>
      SendRequestResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<SendRequestResDatum>.from(
            json["resData"].map((x) => SendRequestResDatum.fromJson(x))),
      );
}

class SendRequestResDatum {
  SendRequestResDatum({
    this.field,
    required this.code,
  });

  String? field;
  String code;

  factory SendRequestResDatum.fromJson(Map<String, dynamic> json) =>
      SendRequestResDatum(
        field: json["field"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "field": field,
        "code": code,
      };
}
