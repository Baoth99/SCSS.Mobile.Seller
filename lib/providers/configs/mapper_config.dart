import 'package:automap/automap.dart';
import 'package:seller_app/blocs/booking_location_picker_bloc.dart';
import 'package:seller_app/providers/models/response/predict_place_goong_map_response_model.dart';

void configureMappers() async {
  AutoMapper.I
      .addManualMap<PredictPlaceGoongMapResponseModel, List<AddressPrediction>>(
    (s, mapper, params) {
      var result = s.predictions
          .map(
            (e) => AddressPrediction(
                placeId: e.placeId,
                mainText: e.structuredFormatting.mainText,
                secondaryText: e.structuredFormatting.secondaryText),
          )
          .toList();
      return result;
    },
  );
}
