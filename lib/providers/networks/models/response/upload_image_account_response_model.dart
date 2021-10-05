import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

UploadImageAccountResponseModel uploadImageAccountResponseModelFromJson(
        String str) =>
    UploadImageAccountResponseModel.fromJson(json.decode(str));

class UploadImageAccountResponseModel extends BaseResponseModel {
  UploadImageAccountResponseModel({
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
  String? resData;

  factory UploadImageAccountResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadImageAccountResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
