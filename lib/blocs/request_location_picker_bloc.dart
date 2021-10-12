import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

part 'events/request_location_picker_event.dart';
part 'states/request_location_picker_state.dart';

class RequestLocationPickerBloc
    extends Bloc<RequestLocationPickerEvent, RequestLocationPickerState> {
  late GoongMapService _goongMapService;
  RequestLocationPickerBloc({GoongMapService? goongMapService})
      : super(const RequestLocationPickerState()) {
    _goongMapService = goongMapService ?? getIt.get<GoongMapService>();
  }

  @override
  Stream<RequestLocationPickerState> mapEventToState(
      RequestLocationPickerEvent event) async* {
    if (event is RequestLocationPickerSearchChanged) {
      if (event.searchValue.isEmpty) {
        yield state.copyWith(
          predictions: const [],
          status: FormzStatus.submissionSuccess,
        );
      } else {
        try {
          // sET STATus in progress
          yield state.copyWith(
            predictions: const [],
            status: FormzStatus.submissionInProgress,
          );

          //CAll API
          var listAddressPrediction =
              await _goongMapService.getPredictions(event.searchValue);
          //API

          //set data list
          yield state.copyWith(
            predictions: listAddressPrediction,
            status: FormzStatus.submissionSuccess,
          );
        } catch (e) {
          print(e);
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
  }
}
