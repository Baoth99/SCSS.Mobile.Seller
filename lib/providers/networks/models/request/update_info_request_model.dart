import 'dart:convert';

import 'package:seller_app/utils/extension_methods.dart';

String updateInfoRequestModelToJson(UpdateInfoRequestModel data) =>
    json.encode(data.toJson());

class UpdateInfoRequestModel {
  UpdateInfoRequestModel({
    this.name,
    this.email,
    this.gender,
    this.birthDate,
    this.address,
    this.imageUrl,
  });

  String? name;
  String? email;
  int? gender;
  DateTime? birthDate;
  String? address;
  String? imageUrl;

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "gender": gender,
        "birthDate": birthDate?.toDateString(),
        "address": address,
        "imageUrl": imageUrl,
      };
}
