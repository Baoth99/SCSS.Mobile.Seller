import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seller_app/blocs/models/yes_no_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/exceptions/custom_exceptions.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/collecting_request_network.dart';
import 'package:seller_app/providers/networks/models/request/cancel_request_request_model.dart';
import 'package:seller_app/providers/networks/models/request/send_request_request_model.dart';
import 'package:seller_app/providers/networks/models/response/send_request_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class CollectingRequestService {
  Future<List<DateTime>> getChosableDates();
  Future<String> sendRequest(
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

  Future<bool> getRequestAbility();

  Future<List<TimeOfDay>> getOperatingTime();

  Future<bool> cancelRequest(String requestId, String cancelReason);
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
  Future<String> sendRequest(
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
      return responseModle.resData;
    } else if (responseModle.statusCode == NetworkConstants.badRequest400) {
      var data = responseModle.resData;
      if (data is List<SendRequestResDatum>) {
        if (data.isNotEmpty) {
          throw BadRequestException(data[0].code);
        }
      } else {
        throw Exception(NetworkConstants.systemError);
      }
    }
    throw Exception(NetworkConstants.systemError);
  }

  @override
  Future<bool> getRequestAbility() async {
    Client client = Client();
    var responseModel =
        await _collectingRequestNetwork.requestAbility(client).whenComplete(
              () => client.close(),
            );
    var data = responseModel.resData;
    if (data != null) {
      return data.isFull;
    }

    throw Exception();
  }

  @override
  Future<List<TimeOfDay>> getOperatingTime() async {
    Client client = Client();
    var responseModel = await _collectingRequestNetwork
        .getOperatingTime(client)
        .whenComplete(() => client.close());

    var data = responseModel.resData;
    if (data != null) {
      var fromTime =
          CommonUtils.convertStringToTimeOfDay(data.operatingFromTime);
      var toTime = CommonUtils.convertStringToTimeOfDay(data.operatingToTime);

      return [fromTime, toTime];
    }
    throw Exception('Do not have operating time');
  }

  @override
  Future<bool> cancelRequest(String requestId, String cancelReason) async {
    Client client = Client();
    var responseModel = await _collectingRequestNetwork
        .cancelRequest(
          CancelRequestRequestModel(
            id: requestId,
            cancelReason: cancelReason,
          ),
          client,
        )
        .whenComplete(() => client.close());

    return responseModel.statusCode == NetworkConstants.ok200 &&
        responseModel.isSuccess!;
  }
}
