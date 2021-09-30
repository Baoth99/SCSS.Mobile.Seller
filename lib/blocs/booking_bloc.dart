import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/booking_model.dart';
import 'package:seller_app/blocs/models/yes_no_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/exceptions/custom_exceptions.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/providers/services/map_service.dart';
part 'events/booking_event.dart';
part 'states/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  late GoongMapService _goongMapService;
  late CollectingRequestService _collectingRequestService;
  late IdentityServerService _identityServerService;

  BookingBloc({
    GoongMapService? goongMapService,
    CollectingRequestService? collectingRequestService,
    IdentityServerService? identityServerService,
  }) : super(BookingState(imageFile: Others.emptyFile)) {
    _goongMapService = goongMapService ?? getIt.get<GoongMapService>();
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

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

      yield state.copyWith(
        address: address,
        status: validate(address, state.date, state.fromTime, state.toTime),
      );
    } else if (event is BookingAddressTapped) {
      var response = await _goongMapService.getPlaceDetail(event.placeId);

      var address = BookingAddress.dirty(
        BookingAddressInfo(
          latitude: response.latitude,
          longitude: response.longitude,
          name: response.name,
          address: response.address,
        ),
      );
      yield state.copyWith(
        address: address,
        status: validate(address, state.date, state.fromTime, state.toTime),
      );
    } else if (event is BookingTimePicked) {
      yield state.copyWith(
        date: event.date,
        fromTime: event.fromTime,
        toTime: event.toTime,
        status:
            validate(state.address, event.date, event.fromTime, event.toTime),
      );
    } else if (event is BookingNoteChanged) {
      yield state.copyWith(
        note: event.value,
      );
    } else if (event is BookingBulkyChosen) {
      yield state.copyWith(
        bulky: event.value,
      );
    } else if (event is BookingImageAdded) {
      yield state.copyWith(
        imageFile: event.image,
      );
    } else if (event is BookingImageDeleted) {
      yield state.copyWith(
        imageFile: Others.emptyFile,
      );
    } else if (event is BookingStateInitial) {
      yield state.refresh();
    } else if (event is BookingAddressInitial) {
      final currentLatLng = await acquireCurrentLocation();
      if (currentLatLng != null) {
        final model = await _goongMapService.getPlaceNameByLatlng(
            currentLatLng.latitude, currentLatLng.longitude);

        var address = BookingAddress.dirty(
          BookingAddressInfo(
            address: model.address,
            name: model.name,
            latitude: currentLatLng.latitude,
            longitude: currentLatLng.longitude,
          ),
        );

        yield state.copyWith(
          address: address,
          status: validate(address, state.date, state.fromTime, state.toTime),
        );
      }
    } else if (event is RequestSummited) {
      // show progress dialog
      yield state.copyWith(
        status: FormzStatus.submissionInProgress,
      );

      // handle business

      try {
        if (validate(
          state.address,
          state.date,
          state.fromTime,
          state.toTime,
        ).isValid) {
          //post data
          bool result = await _sendRequest(state).catchError(
            (value) async {
              var refreshTokenresult =
                  await _identityServerService.refreshToken();
              if (refreshTokenresult) {
                return await _sendRequest(state);
              }
              return false;
            },
            test: (error) => error is UnauthorizedException,
          ).timeout(
            const Duration(minutes: 10),
            onTimeout: () => throw Exception(),
          );

          //success
          if (result) {
            //refresh
            add(BookingStateInitial());

            //
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception();
          }
        }
      } on Exception {
        //turn of dialog
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
        yield state.copyWith(
          status: FormzStatus.pure,
        );
      }
    }
  }

  Future<bool> _sendRequest(BookingState state) async {
    return _collectingRequestService.sendRequest(
      state.address.value.name!,
      state.address.value.address!,
      state.address.value.latitude!,
      state.address.value.longitude!,
      state.date!,
      state.fromTime!,
      state.toTime!,
      state.note,
      state.bulky,
      state.imageFile,
    );
  }

  FormzStatus validate(
    BookingAddress address,
    DateTime? date,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
  ) {
    if (address.valid && date != null && fromTime != null && toTime != null) {
      return FormzStatus.valid;
    }
    return FormzStatus.invalid;
  }
}
