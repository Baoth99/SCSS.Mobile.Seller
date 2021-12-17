import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/request/cancel_request_request_model.dart';
import 'package:seller_app/providers/networks/models/request/send_request_request_model.dart';
import 'package:seller_app/providers/networks/models/response/base_response_model.dart';
import 'package:seller_app/providers/networks/models/response/operating_time_response_model.dart';
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

  Future<OperatingTimeResponseModel> getOperatingTime(Client client);

  Future<BaseResponseModel> cancelRequest(
      CancelRequestRequestModel requestModel, Client client);
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

    var responseModel = _getSendRequestResponseModel(response);

    return responseModel;
  }

  Future<SendRequestResponseModel> _getSendRequestResponseModel(
      Response response) async {
    if (response.statusCode == NetworkConstants.ok200) {
      SendRequestResponseModel responseModel;
      Map<String, dynamic> jsonMap = json.decode(response.body);
      //get status code
      int statusCode = jsonMap["statusCode"];

      // switch case status code

      switch (statusCode) {
        case NetworkConstants.ok200:
          responseModel =
              await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
                  SendRequestResponseModel>(
            response,
            sendRequestResponseModelFromJson200,
          );
          return responseModel;
        case NetworkConstants.badRequest400:
          responseModel = sendRequestResponseModelFromJson400(response.body);

          return responseModel;
        default:
          throw Exception('${NetworkConstants.not200Exception} and 400');
      }
    } else {
      throw Exception(NetworkConstants.not200Exception);
    }
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

  @override
  Future<OperatingTimeResponseModel> getOperatingTime(Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.operatingTime,
      client: client,
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<OperatingTimeResponseModel>(
      response,
      operatingTimeResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> cancelRequest(
      CancelRequestRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.putBodyWithBearerAuth(
      uri: APIServiceURI.cancelRequest,
      client: client,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: cancelRequestRequestModelToJson(requestModel),
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
