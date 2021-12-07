import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

part 'states/request_map_picker_state.dart';
part 'events/request_map_picker_event.dart';

class RequestMapPickerBloc
    extends Bloc<RequestMapPickerEvent, RequestMapPickerState> {
  late GoongMapService _goongMapService;
  RequestMapPickerBloc({
    GoongMapService? goongMapService,
  }) : super(const RequestMapPickerState()) {
    _goongMapService = goongMapService ?? getIt.get<GoongMapService>();
  }

  @override
  Stream<RequestMapPickerState> mapEventToState(
      RequestMapPickerEvent event) async* {
    if (event is RequestMapPickerMapChanged) {
      if (state.latitude != event.latitude ||
          state.longitude != event.longitude) {
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          //API
          var result = await _goongMapService.getPlaceNameByLatlng(
            event.latitude,
            event.longitude,
          );

          //API

          yield state.copyWith(
            placeId: result.placeId,
            latitude: event.latitude,
            longitude: event.longitude,
            placeName: result.name,
            address: result.address,
            district: result.district,
            city: result.city,
            status: FormzStatus.submissionSuccess,
          );
        } catch (e) {
          yield state.copyWith(
            latitude: event.latitude,
            longitude: event.longitude,
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
    // else if (event is RequestMapPickerMapInitial) {
    //   var latlnd = await acquireCurrentLocation();
    //   if (latlnd != null) {
    //     yield state.copyWith(
    //       latitude: latlnd.latitude,
    //       longitude: latlnd.longitude,
    //       status: FormzStatus.submissionFailure,
    //     );
    //   }
    // }
  }
}
