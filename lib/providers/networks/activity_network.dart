import 'dart:io';

import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/request/create_comlaint_request_model.dart';
import 'package:seller_app/providers/networks/models/request/feedback_transaction_requets_model.dart';
import 'package:seller_app/providers/networks/models/request/nearest_approved_requets_response_model.dart';
import 'package:seller_app/providers/networks/models/response/activity_detail_response_model.dart';
import 'package:seller_app/providers/networks/models/response/activity_list_response_model.dart';
import 'package:seller_app/providers/networks/models/response/base_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class ActivityNetwork {
  Future<ActivityListResponseModel> activityGet(
    int status,
    int size,
    int page,
    Client client,
  );

  Future<RequestDetailResponseModel> activityDetail(
    String id,
    Client client,
  );

  Future<BaseResponseModel> createComplaint(
      CreateComplaintequestModel requestModel, Client client);

  Future<BaseResponseModel> feedbackTransaction(
      FeedbackTransactionRequestModel requestModel, Client client);

  Future<NearestApprovedRequestResponseModel> getNearestApprovedRequest(
    Client client,
  );
}

class ActivityNetworkImpl implements ActivityNetwork {
  @override
  Future<ActivityListResponseModel> activityGet(
    int status,
    int size,
    int page,
    Client client,
  ) async {
    var responseModel = ActivityListResponseModel(resData: []);

    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.activityGet,
      client: client,
      queries: {
        'Status': status.toString(),
        'PageSize': size.toString(),
        'Page': page.toString(),
      },
    );
    // get model
    responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ActivityListResponseModel>(
      response,
      activityListResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<RequestDetailResponseModel> activityDetail(
      String id, Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.activityDetail,
      client: client,
      queries: {
        'id': id,
      },
    );
    // get model
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<RequestDetailResponseModel>(
      response,
      requestDetailResponseModelFromJson,
    );
    return responseModel;
  }

  @override
  Future<BaseResponseModel> createComplaint(
      CreateComplaintequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.createComplaint,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: createComplaintRequestModelToJson(requestModel),
      client: client,
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> feedbackTransaction(
      FeedbackTransactionRequestModel requestModel, Client client) async {
    var response = await NetworkUtils.postBodyWithBearerAuth(
      uri: APIServiceURI.feedbackTransaction,
      headers: {
        HttpHeaders.contentTypeHeader: NetworkConstants.applicationJson,
      },
      body: feedbackTransactionRequestModelToJson(requestModel),
      client: client,
    );

    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<NearestApprovedRequestResponseModel> getNearestApprovedRequest(
      Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.nearestApprovedRequest,
      client: client,
    );
    // get model
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            NearestApprovedRequestResponseModel>(
      response,
      nearestApprovedRequestResponseModelFromJson,
    );
    return responseModel;
  }
}
