import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

RequestDetailResponseModel requestDetailResponseModelFromJson(String str) =>
    RequestDetailResponseModel.fromJson(json.decode(str));

class RequestDetailResponseModel extends BaseResponseModel {
  RequestDetailResponseModel({
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

  factory RequestDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      RequestDetailResponseModel(
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
    required this.id,
    required this.createdDate,
    required this.createdTime,
    required this.collectingRequestCode,
    required this.status,
    this.collectorInfo,
    required this.addressName,
    required this.address,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    this.approvedDate,
    this.approvedTime,
    required this.isBulky,
    this.scrapCategoryImageUrl,
    this.note,
    this.transaction,
    this.doneActivityDate,
    this.doneActivityTime,
  });

  String id;
  String createdDate;
  String createdTime;
  String collectingRequestCode;
  int status;
  dynamic collectorInfo;
  String addressName;
  String address;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  dynamic approvedDate;
  dynamic approvedTime;
  bool isBulky;
  String? scrapCategoryImageUrl;
  String? note;
  dynamic transaction;
  dynamic doneActivityDate;
  dynamic doneActivityTime;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        createdDate: json["createdDate"],
        createdTime: json["createdTime"],
        collectingRequestCode: json["collectingRequestCode"],
        status: json["status"],
        collectorInfo: json["collectorInfo"],
        addressName: json["addressName"],
        address: json["address"],
        collectingRequestDate: json["collectingRequestDate"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        approvedDate: json["approvedDate"],
        approvedTime: json["approvedTime"],
        isBulky: json["isBulky"],
        scrapCategoryImageUrl: json["scrapCategoryImageUrl"],
        note: json["note"],
        transaction: json["transaction"],
        doneActivityDate: json["doneActivityDate"],
        doneActivityTime: json["doneActivityTime"],
      );
}
