import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

SendRequestResponseModel sendRequestResponseModelFromJson(String str) =>
    SendRequestResponseModel.fromJson(json.decode(str));

class SendRequestResponseModel extends BaseResponseModel {
  SendRequestResponseModel({
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
  dynamic resData;

  factory SendRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      SendRequestResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
