import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/booking_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

part 'events/booking_event.dart';
part 'states/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(const BookingState());

  final _goongMapService = getIt.get<GoongMapService>();

  @override
  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is BookingAddressPicked) {
      var address = BookingAddress.dirty(
        BookingAddressInfo(
          latitude: event.latitude,
          longitude: event.longitude,
          name: event.name,
          address: event.address,
        ),
      );

      yield state.copyWith(address: address);
    } else if (event is BookingAddressTapped) {
      var response = await _goongMapService.getPlaceDetail(event.placeId);
      yield state.copyWith(
        address: BookingAddress.dirty(
          BookingAddressInfo(
            latitude: response.latitude,
            longitude: response.longitude,
            name: response.name,
            address: response.address,
          ),
        ),
      );
    } else if (event is BookingTimePicked) {
      yield state.copyWith(
        date: BookingDate.dirty(event.date),
        fromTime: BookingTime.dirty(event.fromTime),
        toTime: BookingTime.dirty(event.toTime),
      );
    } else if (event is BookingNoteChanged) {
      yield state.copyWith(
        note: event.value,
      );
    } else if (event is BookingStateInitial) {
      yield state.refresh();
    }
  }
}
