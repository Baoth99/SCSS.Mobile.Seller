import 'dart:convert';

String feedbackTransactionRequestModelToJson(FeedbackAdminRequestModel data) =>
    json.encode(data.toJson());

class FeedbackAdminRequestModel {
  FeedbackAdminRequestModel({
    required this.collectingRequestId,
    required this.sellingFeedback,
  });

  String collectingRequestId;
  String sellingFeedback;

  Map<String, dynamic> toJson() => {
        "collectingRequestId": collectingRequestId,
        "sellingFeedback": sellingFeedback,
      };
}
