import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

part 'states/booking_map_picker_state.dart';
part 'events/booking_map_picker_event.dart';

class BookingMapPickerBloc
    extends Bloc<BookingMapPickerEvent, BookingMapPickerState> {
  BookingMapPickerBloc() : super(const BookingMapPickerState());

  final goongMapService = getIt.get<GoongMapService>();

  @override
  Stream<BookingMapPickerState> mapEventToState(
      BookingMapPickerEvent event) async* {
    if (event is BookingMapPickerMapChanged) {
      if (state.latitude != event.latitude ||
          state.longitude != event.longitude) {
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          //API
          var result = await goongMapService.getPlaceNameByLatlng(
            event.latitude,
            event.longitude,
          );

          //API

          yield state.copyWith(
            latitude: event.latitude,
            longitude: event.longitude,
            placeName: result.name,
            address: result.address,
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
    // else if (event is BookingMapPickerMapInitial) {
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
