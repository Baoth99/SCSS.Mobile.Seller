import 'package:automap/automap.dart';
import 'package:seller_app/blocs/request_location_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/response/place_detail_by_place_id_response_model.dart';
import 'package:seller_app/providers/networks/models/response/predict_place_goong_map_response_model.dart';
import 'package:seller_app/providers/services/models/place_detail_service_model.dart';

void configureMappers() async {
  AutoMapper.I
    ..addManualMap<PredictPlaceGoongMapResponseModel, List<AddressPrediction>>(
      (s, mapper, params) {
        var result = s.predictions
            .map(
              (e) => AddressPrediction(
                placeId: e.placeId,
                mainText: e.structuredFormatting.mainText,
                secondaryText: e.structuredFormatting.secondaryText,
                district: e.compound.district,
                city: e.compound.province,
              ),
            )
            .toList();
        return result;
      },
    )
    ..addManualMap<PlaceDetailByPlaceIdResponseModel, PlaceDetailServiceModel>(
      (source, mapper, params) => PlaceDetailServiceModel(
        source.result?.geometry?.location?.lat ?? 0,
        source.result?.geometry?.location?.lng ?? 0,
        source.result?.name ?? Symbols.empty,
        source.result?.formattedAddress ?? Symbols.empty,
      ),
    );
}
