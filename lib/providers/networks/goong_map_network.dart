import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/request/place_detail_by_place_id_request_model.dart';
import 'package:seller_app/providers/networks/models/request/predict_place_goong_map_request_model.dart';
import 'package:seller_app/providers/networks/models/request/reverse_geocoding_request_model.dart';
import 'package:seller_app/providers/networks/models/response/place_detail_by_place_id_response_model.dart';
import 'package:seller_app/providers/networks/models/response/predict_place_goong_map_response_model.dart';
import 'package:seller_app/providers/networks/models/response/reverse_geocoding_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:seller_app/utils/env_util.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class GoongMapNetwork {
  Future<PredictPlaceGoongMapResponseModel> getPredictions(
      PredictPlaceGoongMapRequestModel requestModel);

  Future<ReverseGeocodingResponseModel> getReverseGeocoding(
      ReverseGeocodingRequestModel requestModel);

  Future<PlaceDetailByPlaceIdResponseModel> getPlaceDetailByPlaceId(
      PlaceDetailByPlaceIdRequestModel requestModel);
}

class GoongMapNetworkImpl implements GoongMapNetwork {
  @override
  Future<PredictPlaceGoongMapResponseModel> getPredictions(
      PredictPlaceGoongMapRequestModel requestModel) async {
    // query string in url
    final queryParameters;

    if (requestModel.latitude != null && requestModel.longitude != null) {
      String locationValue = CommonUtils.concatString(
        [
          requestModel.latitude.toString(),
          requestModel.longitude.toString(),
        ],
        Symbols.comma,
      );

      queryParameters = {
        GoongMapAPIConstants.apiKeyParamName: EnvMapSettingValue.apiKey,
        GoongMapAPIConstants.inputParamName: requestModel.predictValue,
        GoongMapAPIConstants.locationParamName: locationValue
      };
    } else {
      queryParameters = {
        GoongMapAPIConstants.apiKeyParamName: EnvMapSettingValue.apiKey,
        GoongMapAPIConstants.inputParamName: requestModel.predictValue,
      };
    }

    // create uri
    final uri = Uri.https(
      EnvMapSettingValue.apiUrl,
      GoongMapAPIConstants.urlPlacesSearchByKeywordURL,
      queryParameters,
    );

    // call api
    var response = await http.get(uri);

    //convert json to responseModel
    var responseModel = PredictPlaceGoongMapResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }

  @override
  Future<ReverseGeocodingResponseModel> getReverseGeocoding(
      ReverseGeocodingRequestModel requestModel) async {
    // query string in url
    final latlng = CommonUtils.concatString(
      [
        requestModel.latitude.toString(),
        requestModel.longitude.toString(),
      ],
      Symbols.comma,
    );

    // create query param
    final queryParameters = {
      GoongMapAPIConstants.latlngParamName: latlng,
      GoongMapAPIConstants.apiKeyParamName: EnvMapSettingValue.apiKey,
    };

    // create uri
    final uri = Uri.https(
      EnvMapSettingValue.apiUrl,
      GoongMapAPIConstants.urlReverseGeocoding,
      queryParameters,
    );

    // call api
    final response = await http.get(uri);

    //convert json to responseModel
    final responseModel = ReverseGeocodingResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }

  @override
  Future<PlaceDetailByPlaceIdResponseModel> getPlaceDetailByPlaceId(
      PlaceDetailByPlaceIdRequestModel requestModel) async {
    // create query param
    final queryParameters = {
      GoongMapAPIConstants.placeIdParamName: requestModel.placeId,
      GoongMapAPIConstants.apiKeyParamName: EnvMapSettingValue.apiKey,
    };

    // create uri
    final uri = Uri.https(
      EnvMapSettingValue.apiUrl,
      GoongMapAPIConstants.urlGetPlaceDetailById,
      queryParameters,
    );

    // call api
    final response = await http.get(uri);

    //convert json to responseModel
    final responseModel = PlaceDetailByPlaceIdResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }
}