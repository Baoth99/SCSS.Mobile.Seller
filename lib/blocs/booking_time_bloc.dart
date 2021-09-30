import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:seller_app/utils/extension_methods.dart';
part 'states/booking_time_state.dart';
part 'events/booking_time_event.dart';

enum BookingTimeStatus {
  valid,
  lessThanNow,
  notenough15fromtime,
  rangeTimeBetweenTwonotenough,
  pure,
}

class BookingTimeBloc extends Bloc<BookingTimeEvent, BookingTimeState> {
  BookingTimeBloc()
      : super(
          BookingTimeState(
            date: DateTime.now(),
            fromTime: CommonUtils.getNearMinute(
                BookingMapPickerLayoutConstants.minuteInterval),
            toTime: CommonUtils.addTimeOfDay(
                CommonUtils.getNearMinute(
                    BookingMapPickerLayoutConstants.minuteInterval),
                BookingMapPickerLayoutConstants.minuteInterval),
          ),
        );

  final _collectingRequestService = getIt.get<CollectingRequestService>();

  @override
  Stream<BookingTimeState> mapEventToState(BookingTimeEvent event) async* {
    if (event is BookingTimeDatePicked) {
      yield state.copyWith(
        date: event.date,
        status: validate(event.date, state.fromTime, state.toTime),
      );
    } else if (event is BookingTimeTimeFromPicked) {
      final fromTime = TimeOfDay.fromDateTime(event.time);
      yield state.copyWith(
        fromTime: fromTime,
        status: validate(state.date, fromTime, state.toTime),
      );
    } else if (event is BookingTimeTimeToPicked) {
      final toTime = TimeOfDay.fromDateTime(event.time);
      yield state.copyWith(
        toTime: toTime,
        status: validate(state.date, state.fromTime, toTime),
      );
    } else if (event is BookingTimeInitial) {
      try {
        //start prgoressive
        yield state.copyWith(
          blocStatus: FormzStatus.submissionInProgress,
        );

        final chosableDates =
            await _collectingRequestService.getChosableDates();

        // check currentTime
        var nearestTime = CommonUtils.getNearDateTime(
            BookingMapPickerLayoutConstants.minuteInterval);
        if (CommonUtils.compareTwoTimeOfDays(
                TimeOfDay.fromDateTime(nearestTime),
                const TimeOfDay(hour: 23, minute: 45)) ==
            CompareConstants.equal) {
          nearestTime = nearestTime.add(
            const Duration(
                minutes: BookingMapPickerLayoutConstants.minuteInterval),
          );
        }

        if (chosableDates.isNotEmpty) {
          if (chosableDates[0].isSameDate(nearestTime)) {
            final fromTime = TimeOfDay.fromDateTime(nearestTime);
            final toTime = TimeOfDay.fromDateTime(
              nearestTime.add(
                const Duration(
                  minutes: BookingMapPickerLayoutConstants.minuteInterval,
                ),
              ),
            );

            yield state.copyWith(
              date: nearestTime,
              fromTime: fromTime,
              toTime: toTime,
              chosableDates: chosableDates,
              status: validate(nearestTime, fromTime, toTime),
            );
          } else {
            final fromTime = const TimeOfDay(hour: 0, minute: 0);
            final toTime = const TimeOfDay(hour: 0, minute: 15);
            yield state.copyWith(
              date: chosableDates[0],
              fromTime: fromTime,
              toTime: toTime,
              chosableDates: chosableDates,
              status: validate(chosableDates[0], fromTime, toTime),
            );
          }
        }

        //turn off progress bar
        yield state.copyWith(
          blocStatus: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        //turn off progress bar
        yield state.copyWith(
          blocStatus: FormzStatus.submissionFailure,
        );
      }
      //
      yield state.copyWith(
        blocStatus: FormzStatus.pure,
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

  BookingTimeStatus validate(
      DateTime date, TimeOfDay fromTime, TimeOfDay toTime,
      [TimeOfDay? nowtime, DateTime? now]) {
    nowtime ??= TimeOfDay.now();
    now ??= DateTime.now();

    if (date.isSameDate(now)) {
      if (CommonUtils.compareTwoTimeOfDays(fromTime, nowtime) <= 0) {
        return BookingTimeStatus.lessThanNow;
      } else if (CommonUtils.differenceTwoTimeOfDay(fromTime, nowtime) <= 15) {
        return BookingTimeStatus.notenough15fromtime;
      }
    }

    if (CommonUtils.compareTwoTimeOfDays(fromTime, toTime) >= 0) {
      return BookingTimeStatus.rangeTimeBetweenTwonotenough;
    }

    return BookingTimeStatus.valid;
  }
}
