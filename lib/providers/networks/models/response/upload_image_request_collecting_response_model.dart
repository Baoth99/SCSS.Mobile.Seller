import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

UploadImageRequestCollectingResponseModel
    uploadImageRequestCollectingResponseModelFromJson(String str) =>
        UploadImageRequestCollectingResponseModel.fromJson(json.decode(str));

class UploadImageRequestCollectingResponseModel extends BaseResponseModel {
  UploadImageRequestCollectingResponseModel({
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

  factory UploadImageRequestCollectingResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UploadImageRequestCollectingResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: json["resData"],
      );
}
