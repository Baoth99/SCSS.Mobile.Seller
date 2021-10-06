// To parse this JSON data, do
//
//     final requestAbilityResponseModel = requestAbilityResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

RequestAbilityResponseModel requestAbilityResponseModelFromJson(String str) =>
    RequestAbilityResponseModel.fromJson(json.decode(str));

class RequestAbilityResponseModel extends BaseResponseModel {
  RequestAbilityResponseModel({
    bool? isSuccess,
    int? statusCode,
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

  factory RequestAbilityResponseModel.fromJson(Map<String, dynamic> json) =>
      RequestAbilityResponseModel(
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
    required this.isFull,
    required this.numberOfRemainingRequest,
  });

  bool isFull;
  int numberOfRemainingRequest;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        isFull: json["isFull"],
        numberOfRemainingRequest: json["numberOfRemainingRequest"],
      );

  Map<String, dynamic> toJson() => {
        "isFull": isFull,
        "numberOfRemainingRequest": numberOfRemainingRequest,
      };
}
