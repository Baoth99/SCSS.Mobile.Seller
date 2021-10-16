import 'dart:convert';

String createComplaintRequestModelToJson(CreateComplaintequestModel data) =>
    json.encode(data.toJson());

class CreateComplaintequestModel {
  CreateComplaintequestModel({
    required this.collectingRequestId,
    required this.complaintContent,
  });

  String collectingRequestId;
  String complaintContent;

  Map<String, dynamic> toJson() => {
        "collectingRequestId": collectingRequestId,
        "complaintContent": complaintContent,
      };
}
