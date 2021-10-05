import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/request/send_request_request_model.dart';
import 'package:seller_app/providers/networks/models/response/remaining_days_response_model.dart';
import 'package:seller_app/providers/networks/models/response/requets_ability_response_model.dart';
import 'package:seller_app/providers/networks/models/response/send_request_response_model.dart';
import 'package:seller_app/providers/networks/models/response/upload_image_request_collecting_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:uuid/uuid.dart';

abstract class CollectingRequestNetwork {
  Future<RemainingDaysResponseModel> getRemainingDays(
    Client client,
  );
  Future<UploadImageRequestCollectingResponseModel> uploadImage(
    List<int> listIntImage,
    Client client,
  );

  Future<SendRequestResponseModel> request(
    SendRequestRequestModel requestModel,
    Client client,
  );

  Future<RequestAbilityResponseModel> requestAbility(Client client);
}

class CollectingRequestNetworkImpl extends CollectingRequestNetwork {
  @override
  Future<RemainingDaysResponseModel> getRemainingDays(
    Client client,
  ) async {
    var responseModel = RemainingDaysResponseModel(resData: []);

    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.collectingRequestRemainingDays,
      client: client,
    );
    // get model
    responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<RemainingDaysResponseModel>(
      response,
      remainingDaysResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<SendRequestResponseModel> request(
    SendRequestRequestModel requestModel,
    Client client,
  ) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.collectingRequestRequest,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: jsonEncode(requestModel.toJson()),
      client: client,
    );

    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<SendRequestResponseModel>(
      response,
      sendRequestResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<UploadImageRequestCollectingResponseModel> uploadImage(
    List<int> listIntImage,
    Client client,
  ) async {
    var response = await NetworkUtils.postMultipart(
      APIServiceURI.collectingRequestUploadImg,
      {},
      MultipartFile.fromBytes(
        'Image',
        listIntImage,
        filename: '${Uuid().v1()}.jpg',
      ),
      client,
    );

    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            UploadImageRequestCollectingResponseModel>(
      response,
      uploadImageRequestCollectingResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<RequestAbilityResponseModel> requestAbility(Client client) async {
    RequestAbilityResponseModel responseModel = RequestAbilityResponseModel(
      isSuccess: false,
      statusCode: 500,
    );

    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.requestAbility,
      client: client,
    );
    // get model
    responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            RequestAbilityResponseModel>(
      response,
      requestAbilityResponseModelFromJson,
    );
    return responseModel;
  }
}
