import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

part 'events/booking_location_picker_event.dart';
part 'states/booking_location_picker_state.dart';

class BookingLocationPickerBloc
    extends Bloc<BookingLocationPickerEvent, BookingLocationPickerState> {
  BookingLocationPickerBloc() : super(const BookingLocationPickerState());

  final _goongMapService = getIt.get<GoongMapService>();

  @override
  Stream<BookingLocationPickerState> mapEventToState(
      BookingLocationPickerEvent event) async* {
    if (event is BookingLocationPickerSearchChanged) {
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
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
  }
}
