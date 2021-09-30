import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seller_app/blocs/models/yes_no_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/collecting_request_network.dart';
import 'package:seller_app/providers/networks/models/request/send_request_request_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class CollectingRequestService {
  Future<List<DateTime>> getChosableDates();
  Future<bool> sendRequest(
    String addressName,
    String address,
    double latitude,
    double longitude,
    DateTime collectingRequestDate,
    TimeOfDay fromTime,
    TimeOfDay toTime,
    String note,
    YesNo isBulky,
    File imageFile,
  );
}

class CollectingRequestServiceImpl implements CollectingRequestService {
  late CollectingRequestNetwork _collectingRequestNetwork;
  CollectingRequestServiceImpl({
    CollectingRequestNetwork? collectingRequestNetwork,
  }) {
    _collectingRequestNetwork =
        collectingRequestNetwork ?? getIt.get<CollectingRequestNetwork>();
  }

  @override
  Future<List<DateTime>> getChosableDates() async {
    Client client = Client();
    var responseModel = await _collectingRequestNetwork
        .getRemainingDays(
          client,
        )
        .whenComplete(() => client.close());
    if (responseModel.isSuccess ?? false) {
      var listDateTime = responseModel.resData?.map((e) => e.date!).toList();
      if (listDateTime != null && listDateTime.isNotEmpty) {
        return listDateTime;
      }
    }
    return [];
  }

  @override
  Future<bool> sendRequest(
    String addressName,
    String address,
    double latitude,
    double longitude,
    DateTime collectingRequestDate,
    TimeOfDay fromTime,
    TimeOfDay toTime,
    String note,
    YesNo isBulky,
    File imageFile,
  ) async {
    Client client = Client();
    String? imageUrl;
    if (imageFile.path.isNotEmpty) {
      var imageBase64 = CommonUtils.convertImageToBasae64(imageFile);

      // call API upload Image
      var imageResponseModel = await _collectingRequestNetwork.uploadImage(
        imageBase64,
        client,
      );
      if (imageResponseModel.statusCode == NetworkConstants.ok200 &&
          imageResponseModel.isSuccess!) {
        imageUrl = imageResponseModel.resData;
      } else {
        throw Exception();
      }
    } else {
      imageUrl = null;
    }

    var requestModel = SendRequestRequestModel(
      addressName: addressName,
      address: address,
      latitude: latitude,
      longtitude: longitude,
      collectingRequestDate: collectingRequestDate,
      fromTime: fromTime,
      toTime: toTime,
      note: note,
      isBulky: isBulky == YesNo.yes,
      collectingRequestImageUrl: imageUrl,
    );

    var responseModle = await _collectingRequestNetwork
        .request(
          requestModel,
          client,
        )
        .whenComplete(() => client.close());
    if (responseModle.statusCode == NetworkConstants.ok200 &&
        responseModle.isSuccess!) {
      return true;
    }
    return false;
  }
}
