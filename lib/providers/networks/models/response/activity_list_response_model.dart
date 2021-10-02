import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

ActivityListResponseModel activityListResponseModelFromJson(String str) =>
    ActivityListResponseModel.fromJson(json.decode(str));

class ActivityListResponseModel extends BaseResponseModel {
  ActivityListResponseModel({
    bool? isSuccess,
    int? statusCode,
    this.msgCode,
    this.msgDetail,
    this.total,
    List<ResDatum>? resData,
  }) : super(
          isSuccess: isSuccess,
          statusCode: statusCode,
        ) {
    this.resData = resData ?? [];
  }

  dynamic msgCode;
  dynamic msgDetail;
  int? total;
  late List<ResDatum> resData;

  factory ActivityListResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityListResponseModel(
        isSuccess: json["isSuccess"],
        statusCode: json["statusCode"],
        msgCode: json["msgCode"],
        msgDetail: json["msgDetail"],
        total: json["total"],
        resData: List<ResDatum>.from(
            json["resData"].map((x) => ResDatum.fromJson(x))),
      );
}

class ResDatum {
  ResDatum({
    required this.collectingRequestId,
    required this.collectingRequestCode,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.status,
    required this.isBulky,
    required this.addressName,
    this.total,
  });

  String collectingRequestId;
  String collectingRequestCode;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  int status;
  bool isBulky;
  String addressName;
  dynamic total;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        collectingRequestId: json["collectingRequestId"],
        collectingRequestCode: json["collectingRequestCode"],
        collectingRequestDate: json["collectingRequestDate"],
        fromTime: json["fromTime"],
        toTime: json["toTime"],
        status: json["status"],
        isBulky: json["isBulky"],
        addressName: json["addressName"],
        total: json["total"],
      );
}
