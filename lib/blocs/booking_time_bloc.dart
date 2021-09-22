import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/booking_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'states/booking_time_state.dart';
part 'events/booking_time_event.dart';

class BookingTimeBloc extends Bloc<BookingTimeEvent, BookingTimeState> {
  BookingTimeBloc()
      : super(
          BookingTimeState(
            date: BookingDate.pure(DateTime.now()),
            fromTime: BookingTime.pure(
              TimeOfDay.fromDateTime(
                CommonUtils.getNearDateTime(
                    BookingMapPickerLayoutConstants.minuteInterval),
              ),
            ),
            toTime: BookingTime.pure(
              CommonUtils.addTimeOfDay(
                  TimeOfDay.fromDateTime(
                    CommonUtils.getNearDateTime(
                        BookingMapPickerLayoutConstants.minuteInterval),
                  ),
                  15),
            ),
          ),
        );

  @override
  Stream<BookingTimeState> mapEventToState(BookingTimeEvent event) async* {
    if (event is BookingTimeDatePicked) {
      yield state.copyWith(
        date: BookingDate.dirty(event.date),
      );
    } else if (event is BookingTimeTimeFromPicked) {
      yield state.copyWith(
        fromTime: BookingTime.dirty(
          TimeOfDay.fromDateTime(event.time),
        ),
      );
    } else if (event is BookingTimeTimeToPicked) {
      yield state.copyWith(
        toTime: BookingTime.dirty(
          TimeOfDay.fromDateTime(event.time),
        ),
      );
    }
    // else if (event is BookingTimeInitial) {
    //   yield state.copyWith(
    //     date: BookingDate.dirty(DateTime.now()),
    //     fromTime: BookingTime.dirty(
    //       TimeOfDay.fromDateTime(
    //         CommonUtils.getNearDateTime(
    //             BookingMapPickerLayoutConstants.minuteInterval),
    //       ),
    //     ),
    //     toTime: BookingTime.dirty(
    //       TimeOfDay.fromDateTime(
    //         CommonUtils.getNearDateTime(
    //             BookingMapPickerLayoutConstants.minuteInterval),
    //       ),
    //     ),
    //   );
    // }
  }
}
