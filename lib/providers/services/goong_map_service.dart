import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:seller_app/blocs/request_bloc.dart';
import 'package:seller_app/blocs/request_location_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/goong_map_network.dart';
import 'package:automap/automap.dart';
import 'package:seller_app/providers/networks/models/request/place_detail_by_place_id_request_model.dart';
import 'package:seller_app/providers/networks/models/request/predict_place_goong_map_request_model.dart';
import 'package:seller_app/providers/networks/models/request/reverse_geocoding_request_model.dart';
import 'package:seller_app/providers/networks/models/response/place_detail_by_place_id_response_model.dart';
import 'package:seller_app/providers/networks/models/response/predict_place_goong_map_response_model.dart';
import 'package:seller_app/providers/services/map_service.dart';
import 'package:seller_app/providers/services/models/place_detail_service_model.dart';
import 'package:seller_app/providers/services/models/place_name_by_lat_lng_service_model.dart';

abstract class GoongMapService {
  Future<List<AddressPrediction>> getPredictions(String predictionValue);

  Future<PlaceNameByLatlngServiceModel> getPlaceNameByLatlng(
      double latitude, double longitude);

  Future<PlaceDetailServiceModel> getPlaceDetail(String placeId);

  Future<List<PersonalLocation>> getPersonalLocations();

  Future<bool> removePersonalLocation(String id);
}

class GoongMapServiceImpl implements GoongMapService {
  GoongMapServiceImpl({GoongMapNetwork? goongMapNetwork}) {
    _goongMapNetwork = goongMapNetwork ?? getIt.get<GoongMapNetwork>();
  }

  late GoongMapNetwork _goongMapNetwork;

  @override
  Future<List<AddressPrediction>> getPredictions(String predictionValue) async {
    final latLng = await acquireCurrentLocation();

    //call api by network
    var client = Client();
    var responseModel = await _goongMapNetwork
        .getPredictions(
          PredictPlaceGoongMapRequestModel(
            predictValue: predictionValue,
            latitude: (latLng?.latitude) ?? MapConstants.hoChiMinhLatitude,
            longitude: (latLng?.longitude) ?? MapConstants.hoChiMinhLongitude,
          ),
          client,
        )
        .whenComplete(() => client.close());

    //map responseModel to List<AddressPrediction>
    var listAddressPrediction = AutoMapper.I
        .map<PredictPlaceGoongMapResponseModel, List<AddressPrediction>>(
            responseModel);

    return listAddressPrediction;
  }

  @override
  Future<PlaceNameByLatlngServiceModel> getPlaceNameByLatlng(
      double latitude, double longitude) async {
    //call api by net work
    var client = Client();
    var responseModel = await _goongMapNetwork
        .getReverseGeocoding(
          ReverseGeocodingRequestModel(
              latitude: latitude, longitude: longitude),
          client,
        )
        .whenComplete(() => client.close());
    var firstResult = responseModel.results?[0];

    var addressComponents = firstResult?.addressComponents;

    if (addressComponents != null) {
      var name = addressComponents[0].longName;

      var addressList = <String>[];
      for (var i = 1; i < addressComponents.length; i++) {
        addressList.add(addressComponents[i].longName);
      }
      var address = addressList.join('${Symbols.comma} ');

      return PlaceNameByLatlngServiceModel(
        name: name,
        address: address,
        district: addressComponents[addressComponents.length - 2].longName,
        city: addressComponents.last.longName,
      );
    }

    return const PlaceNameByLatlngServiceModel();
  }

  @override
  Future<PlaceDetailServiceModel> getPlaceDetail(String placeId) async {
    var client = Client();
    var responseModel = await _goongMapNetwork
        .getPlaceDetailByPlaceId(
          PlaceDetailByPlaceIdRequestModel(placeId),
          client,
        )
        .whenComplete(() => client.close());

    var result = AutoMapper.I
        .map<PlaceDetailByPlaceIdResponseModel, PlaceDetailServiceModel>(
      responseModel,
    );

    return result;
  }

  @override
  Future<List<PersonalLocation>> getPersonalLocations() async {
    List<PersonalLocation> result = [];
    var client = Client();
    var responseModel = await _goongMapNetwork
        .getPersonalLocations(
          client,
        )
        .whenComplete(() => client.close());
    var data = responseModel.resData;
    if (data.isNotEmpty) {
      result = data
          .map(
            (l) => PersonalLocation(
                id: l.id,
                placeId: l.placeId,
                placeName: l.placeName,
                addressName: l.addressName,
                address: l.address,
                latitude: l.latitude,
                longtitude: l.longtitude,
                district: l.district,
                city: l.city),
          )
          .toList();
    }

    return result;
  }

  @override
  Future<bool> removePersonalLocation(String id) async {
    var client = Client();
    var responseModel = await _goongMapNetwork
        .removePersonalLocation(
          client,
          id,
        )
        .whenComplete(() => client.close());

    if (responseModel.isSuccess != null &&
        responseModel.isSuccess! &&
        responseModel.statusCode == NetworkConstants.ok200) {
      return true;
    }
    return false;
  }
}
