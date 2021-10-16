import 'dart:convert';

import 'package:seller_app/providers/networks/models/response/base_response_model.dart';
import 'package:seller_app/utils/extension_methods.dart';

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
    this.cancelReasoin,
    this.transaction,
    required this.complaint,
    this.doneActivityDate,
    this.doneActivityTime,
    required this.isCancelable,
  });

  String id;
  String createdDate;
  String createdTime;
  String collectingRequestCode;
  int status;
  CollectorInfo? collectorInfo;
  String addressName;
  String address;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  String? approvedDate;
  String? approvedTime;
  bool isBulky;
  String? scrapCategoryImageUrl;
  String? note;
  String? cancelReasoin;
  Transaction? transaction;
  Complaint complaint;
  String? doneActivityDate;
  String? doneActivityTime;
  bool isCancelable;

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        id: json["id"],
        createdDate: json["createdDate"],
        createdTime: json["createdTime"],
        collectingRequestCode: json["collectingRequestCode"],
        status: json["status"],
        collectorInfo: json["collectorInfo"] == null
            ? null
            : CollectorInfo.fromJson(json["collectorInfo"]),
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
        cancelReasoin: json["cancelReasoin"],
        transaction: json["transaction"] == null
            ? null
            : Transaction.fromJson(json["transaction"]),
        complaint: Complaint.fromJson(json["complaint"]),
        doneActivityDate: json["doneActivityDate"],
        doneActivityTime: json["doneActivityTime"],
        isCancelable: json["isCancelable"],
      );
}

class CollectorInfo {
  CollectorInfo({
    required this.name,
    this.imageUrl,
    required this.phone,
    this.rating,
  });

  String name;
  String? imageUrl;
  String phone;
  double? rating;

  factory CollectorInfo.fromJson(Map<String, dynamic> json) => CollectorInfo(
        name: json["name"],
        imageUrl: json["imageURL"],
        phone: json["phone"],
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
      );
}

class Transaction {
  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.transactionTime,
    required this.total,
    required this.fee,
    required this.awardPoint,
    required this.feedbackInfo,
    required this.details,
  });

  String transactionId;
  String transactionDate;
  String transactionTime;
  int total;
  int fee;
  int awardPoint;
  FeedbackInfo feedbackInfo;
  List<Detail> details;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["transactionId"],
        transactionDate: json["transactionDate"],
        transactionTime: json["transactionTime"],
        total: json["total"],
        fee: json["fee"],
        awardPoint: json["awardPoint"],
        feedbackInfo: FeedbackInfo.fromJson(json["feedbackInfo"]),
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );
}

class Detail {
  Detail({
    this.scrapCategoryName,
    this.quantity,
    this.unit,
    required this.total,
  });

  String? scrapCategoryName;
  int? quantity;
  String? unit;
  int total;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        scrapCategoryName: json["scrapCategoryName"],
        quantity: json["quantity"],
        unit: json["unit"],
        total: json["total"],
      );
}

class FeedbackInfo {
  FeedbackInfo({
    required this.feedbackStatus,
    this.feedbackType,
    this.ratingFeedback,
  });

  int feedbackStatus;
  int? feedbackType;
  double? ratingFeedback;

  factory FeedbackInfo.fromJson(Map<String, dynamic> json) => FeedbackInfo(
        feedbackStatus: json["feedbackStatus"],
        feedbackType: json["feedbackType"],
        ratingFeedback: json["ratingFeedback"] == null
            ? 0.0
            : json["ratingFeedback"].toDouble(),
      );
}

class Complaint {
  Complaint({
    this.complaintId,
    required this.complaintStatus,
    this.complaintContent,
    this.adminReply,
  });

  String? complaintId;
  int complaintStatus;
  String? complaintContent;
  String? adminReply;

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        complaintId: json["complaintId"],
        complaintStatus: json["complaintStatus"],
        complaintContent: json["complaintContent"],
        adminReply: json["adminReply"],
      );
}
