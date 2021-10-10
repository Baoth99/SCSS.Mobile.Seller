import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/request_model.dart';
import 'package:seller_app/blocs/models/yes_no_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/exceptions/custom_exceptions.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/providers/services/map_service.dart';
import 'package:seller_app/utils/common_function.dart';
part 'events/request_event.dart';
part 'states/request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  late GoongMapService _goongMapService;
  late CollectingRequestService _collectingRequestService;

  RequestBloc({
    GoongMapService? goongMapService,
    CollectingRequestService? collectingRequestService,
    IdentityServerService? identityServerService,
  }) : super(RequestState(imageFile: Others.emptyFile)) {
    _goongMapService = goongMapService ?? getIt.get<GoongMapService>();
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }

  @override
  Stream<RequestState> mapEventToState(RequestEvent event) async* {
    if (event is RequestAddressPicked) {
      var address = RequestAddress.dirty(
        RequestAddressInfo(
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
    } else if (event is RequestAddressTapped) {
      var response = await _goongMapService.getPlaceDetail(event.placeId);

      var address = RequestAddress.dirty(
        RequestAddressInfo(
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
    } else if (event is RequestTimePicked) {
      yield state.copyWith(
        date: event.date,
        fromTime: event.fromTime,
        toTime: event.toTime,
        status:
            validate(state.address, event.date, event.fromTime, event.toTime),
      );
    } else if (event is RequestNoteChanged) {
      yield state.copyWith(
        note: event.value,
      );
    } else if (event is RequestBulkyChosen) {
      yield state.copyWith(
        bulky: event.value,
      );
    } else if (event is RequestImageAdded) {
      yield state.copyWith(
        imageFile: event.image,
      );
    } else if (event is RequestImageDeleted) {
      yield state.copyWith(
        imageFile: Others.emptyFile,
      );
    } else if (event is RequestStateInitial) {
      yield state.refresh();
    } else if (event is RequestAddressInitial) {
      final currentLatLng = await acquireCurrentLocation();
      if (currentLatLng != null) {
        final model = await _goongMapService.getPlaceNameByLatlng(
            currentLatLng.latitude, currentLatLng.longitude);

        var address = RequestAddress.dirty(
          RequestAddressInfo(
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
          String result = await futureAppDuration<String>(_sendRequest(state));

          //success
          if (result.isNotEmpty) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
              requestId: result,
            );
          } else {
            throw Exception();
          }
        }
      } on BadRequestException catch (exception) {
        print(exception);
        //turn of dialog
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
          errorCode: exception.cause,
        );
        yield state.copyWith(
          status: FormzStatus.pure,
        );
      } on Exception catch (exception) {
        print(exception);
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

  Future<String> _sendRequest(RequestState state) async {
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
    RequestAddress address,
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
