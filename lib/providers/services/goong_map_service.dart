import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:seller_app/blocs/booking_location_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/models/request/predict_place_goong_map_request_model.dart';
import 'package:seller_app/providers/models/request/reverse_geocoding_request_model.dart';
import 'package:seller_app/providers/models/response/predict_place_goong_map_response_model.dart';
import 'package:seller_app/providers/networks/goong_map_network.dart';
import 'package:automap/automap.dart';
import 'package:seller_app/providers/services/map_service.dart';

class GoongMapService {
  final _goongMapNetwork = getIt.get<GoongMapNetwork>();

  Future<List<AddressPrediction>> getPredictions(String predictionValue) async {
    final latLng = await acquireCurrentLocation();

    //call api by network
    var responseModel = await _goongMapNetwork.getPredictions(
      PredictPlaceGoongMapRequestModel(
        predictValue: predictionValue,
        latitude: latLng?.latitude,
        longitude: latLng?.longitude,
      ),
    );

    //map responseModel to List<AddressPrediction>
    var listAddressPrediction = AutoMapper.I
        .map<PredictPlaceGoongMapResponseModel, List<AddressPrediction>>(
            responseModel);

    return listAddressPrediction;
  }

  Future<String> getPlaceNameByLatlng(double latitude, double longitude) async {
    //call api by net work
    var responseModel = await _goongMapNetwork.getReverseGeocoding(
      ReverseGeocodingRequestModel(latitude: latitude, longitude: longitude),
    );
    var firstResult = responseModel.results?[0];

    var result = firstResult?.addressComponents?[0].longName ?? Symbols.empty;

    return result;
  }
}
