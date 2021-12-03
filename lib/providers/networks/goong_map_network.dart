import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/providers/networks/models/request/place_detail_by_place_id_request_model.dart';
import 'package:seller_app/providers/networks/models/request/predict_place_goong_map_request_model.dart';
import 'package:seller_app/providers/networks/models/request/reverse_geocoding_request_model.dart';
import 'package:seller_app/providers/networks/models/response/base_response_model.dart';
import 'package:seller_app/providers/networks/models/response/personal_location_get_response_model.dart';
import 'package:seller_app/providers/networks/models/response/place_detail_by_place_id_response_model.dart';
import 'package:seller_app/providers/networks/models/response/predict_place_goong_map_response_model.dart';
import 'package:seller_app/providers/networks/models/response/reverse_geocoding_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class GoongMapNetwork {
  Future<PredictPlaceGoongMapResponseModel> getPredictions(
    PredictPlaceGoongMapRequestModel requestModel,
    http.Client client,
  );

  Future<ReverseGeocodingResponseModel> getReverseGeocoding(
    ReverseGeocodingRequestModel requestModel,
    http.Client client,
  );

  Future<PlaceDetailByPlaceIdResponseModel> getPlaceDetailByPlaceId(
    PlaceDetailByPlaceIdRequestModel requestModel,
    http.Client client,
  );

  Future<PersonalLocationGetResponseModel> getPersonalLocations(
    http.Client client,
  );

  Future<BaseResponseModel> removePersonalLocation(
      http.Client client, String id);
}

class GoongMapNetworkImpl implements GoongMapNetwork {
  @override
  Future<PredictPlaceGoongMapResponseModel> getPredictions(
    PredictPlaceGoongMapRequestModel requestModel,
    http.Client client,
  ) async {
    // query string in url
    final Map<String, String> queryParameters;

    queryParameters = {
      'KeyWord': requestModel.predictValue,
    };

    if (requestModel.latitude != null && requestModel.longitude != null) {
      queryParameters.addAll({
        'Latitude': requestModel.latitude.toString(),
        'Longtitude': requestModel.longitude.toString(),
      });
    }

    // call api
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: GoongMapAPIConstants.urlPlacesSearchByKeywordURL,
      client: client,
      queries: queryParameters,
    );

    //convert json to responseModel
    var responseModel = PredictPlaceGoongMapResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }

  @override
  Future<ReverseGeocodingResponseModel> getReverseGeocoding(
    ReverseGeocodingRequestModel requestModel,
    http.Client client,
  ) async {
    // create query param
    final queryParameters = {
      'Latitude': requestModel.latitude.toString(),
      'Longtitude': requestModel.longitude.toString(),
    };

    // call api
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: GoongMapAPIConstants.urlReverseGeocoding,
      client: client,
      queries: queryParameters,
    );
    //convert json to responseModel
    final responseModel = ReverseGeocodingResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }

  @override
  Future<PlaceDetailByPlaceIdResponseModel> getPlaceDetailByPlaceId(
    PlaceDetailByPlaceIdRequestModel requestModel,
    http.Client client,
  ) async {
    // create query param
    final queryParameters = {
      'placeid': requestModel.placeId,
    };

    // call api
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: GoongMapAPIConstants.urlGetPlaceDetailById,
      client: client,
      queries: queryParameters,
    );

    //convert json to responseModel
    final responseModel = PlaceDetailByPlaceIdResponseModel.fromJson(
      jsonDecode(response.body),
    );

    return responseModel;
  }

  @override
  Future<PersonalLocationGetResponseModel> getPersonalLocations(
      http.Client client) async {
    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.getPersonalLocation,
      client: client,
    );
    var responseModel =
        await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
            PersonalLocationGetResponseModel>(
      response,
      personalLocationGetResponseModelFromJson,
    );

    return responseModel;
  }

  @override
  Future<BaseResponseModel> removePersonalLocation(
      http.Client client, String id) async {
    var response = await NetworkUtils.deleteNetworkWithBearer(
        uri: APIServiceURI.removePersonalLocation,
        client: client,
        queries: {
          'id': id,
        });
    var responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<BaseResponseModel>(
      response,
      baseResponseModelFromJson,
    );

    return responseModel;
  }
}
