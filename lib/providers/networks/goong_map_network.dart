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
}
