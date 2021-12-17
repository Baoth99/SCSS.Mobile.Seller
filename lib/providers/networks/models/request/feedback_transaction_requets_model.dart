import 'dart:convert';

String feedbackTransactionRequestModelToJson(
        FeedbackTransactionRequestModel data) =>
    json.encode(data.toJson());

class FeedbackTransactionRequestModel {
  FeedbackTransactionRequestModel({
    required this.sellCollectTransactionId,
    required this.rate,
    required this.sellingReview,
  });

  String sellCollectTransactionId;
  double rate;
  String sellingReview;

  Map<String, dynamic> toJson() => {
        "sellCollectTransactionId": sellCollectTransactionId,
        "rate": rate,
        "sellingReview": sellingReview,
      };
}
