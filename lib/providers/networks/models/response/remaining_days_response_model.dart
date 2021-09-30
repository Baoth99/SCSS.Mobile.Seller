import 'dart:convert';
import 'package:seller_app/providers/networks/models/response/base_response_model.dart';

RemainingDaysResponseModel remainingDaysResponseModelFromJson(String str) =>
    RemainingDaysResponseModel.fromJson(json.decode(str));

class RemainingDaysResponseModel extends BaseResponseModel {
  RemainingDaysResponseModel({
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
  int? total;
  List<ResDatum>? resData;

  factory RemainingDaysResponseModel.fromJson(Map<String, dynamic> json) =>
      RemainingDaysResponseModel(
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
    this.count,
    this.date,
  });

  int? count;
  DateTime? date;

  factory ResDatum.fromJson(Map<String, dynamic> json) => ResDatum(
        count: json["count"],
        date: DateTime.parse(json["date"]),
      );
}
