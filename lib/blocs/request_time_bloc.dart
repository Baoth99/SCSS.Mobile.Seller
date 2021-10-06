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
part 'states/request_time_state.dart';
part 'events/request_time_event.dart';

enum RequestTimeStatus {
  valid,
  lessThanNow,
  notenough15fromtime,
  rangeTimeBetweenTwonotenough,
  pure,
  notinrangetime,
}

class RequestTimeBloc extends Bloc<RequestTimeEvent, RequestTimeState> {
  RequestTimeBloc()
      : super(
          RequestTimeState(
            date: DateTime.now(),
            fromTime: CommonUtils.getNearMinute(
                RequestMapPickerLayoutConstants.minuteInterval),
            toTime: CommonUtils.addTimeOfDay(
                CommonUtils.getNearMinute(
                    RequestMapPickerLayoutConstants.minuteInterval),
                RequestMapPickerLayoutConstants.minuteInterval),
          ),
        );

  final _collectingRequestService = getIt.get<CollectingRequestService>();

  @override
  Stream<RequestTimeState> mapEventToState(RequestTimeEvent event) async* {
    if (event is RequestTimeDatePicked) {
      yield state.copyWith(
        date: event.date,
        status: validate(
          event.date,
          state.fromTime,
          state.toTime,
          operatingFromTime: state.operatingFromTime!,
          operatingToTime: state.operatingTotime!,
        ),
      );
    } else if (event is RequestTimeTimeFromPicked) {
      final fromTime = TimeOfDay.fromDateTime(event.time);
      yield state.copyWith(
        fromTime: fromTime,
        status: validate(
          state.date,
          fromTime,
          state.toTime,
          operatingFromTime: state.operatingFromTime!,
          operatingToTime: state.operatingTotime!,
        ),
      );
    } else if (event is RequestTimeTimeToPicked) {
      final toTime = TimeOfDay.fromDateTime(event.time);
      yield state.copyWith(
        toTime: toTime,
        status: validate(
          state.date,
          state.fromTime,
          toTime,
          operatingFromTime: state.operatingFromTime!,
          operatingToTime: state.operatingTotime!,
        ),
      );
    } else if (event is RequestTimeInitial) {
      try {
        //start prgoressive
        yield state.copyWith(
          blocStatus: FormzStatus.submissionInProgress,
        );

        var fchosableDates = _collectingRequestService.getChosableDates();

        // get Operating times
        var foperatingtime = _getOperatingTime();

        var chosableDates = await fchosableDates;
        var operatingtime = await foperatingtime;
        // check currentTime
        var nearestTime = CommonUtils.getNearDateTime(
            RequestMapPickerLayoutConstants.minuteInterval);
        if (CommonUtils.compareTwoTimeOfDays(
                TimeOfDay.fromDateTime(nearestTime),
                const TimeOfDay(hour: 23, minute: 45)) ==
            CompareConstants.equal) {
          nearestTime = nearestTime.add(
            const Duration(
                minutes: RequestMapPickerLayoutConstants.minuteInterval),
          );
        }
        var currentTimeOfday = TimeOfDay.fromDateTime(DateTime.now());
        if (chosableDates.isNotEmpty) {
          TimeOfDay fromTime;
          TimeOfDay toTime;
          if (chosableDates[0].isSameDate(nearestTime)) {
            if (currentTimeOfday.isLessThan(operatingtime[0])) {
              fromTime = operatingtime[0];
              toTime = CommonUtils.addTimeOfDay(operatingtime[0],
                  RequestMapPickerLayoutConstants.minuteInterval);
            } else {
              fromTime = TimeOfDay.fromDateTime(nearestTime);
              toTime = TimeOfDay.fromDateTime(
                nearestTime.add(
                  const Duration(
                    minutes: RequestMapPickerLayoutConstants.minuteInterval,
                  ),
                ),
              );
            }

            yield state.copyWith(
              date: nearestTime,
              fromTime: fromTime,
              toTime: toTime,
              chosableDates: chosableDates,
              status: validate(
                nearestTime,
                fromTime,
                toTime,
                operatingFromTime: operatingtime[0],
                operatingToTime: operatingtime[1],
              ),
              operatingFromTime: operatingtime[0],
              operatingTotime: operatingtime[1],
            );
          } else {
            fromTime = operatingtime[0];
            toTime = CommonUtils.addTimeOfDay(operatingtime[0],
                RequestMapPickerLayoutConstants.minuteInterval);
            yield state.copyWith(
              date: chosableDates[0],
              fromTime: fromTime,
              toTime: toTime,
              chosableDates: chosableDates,
              status: validate(
                chosableDates[0],
                fromTime,
                toTime,
                operatingFromTime: operatingtime[0],
                operatingToTime: operatingtime[1],
              ),
              operatingFromTime: operatingtime[0],
              operatingTotime: operatingtime[1],
            );
          }
        }

        //turn off progress bar
        yield state.copyWith(
          blocStatus: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        //turn off progress bar
        print(e);
        yield state.copyWith(
          blocStatus: FormzStatus.submissionFailure,
        );
      }
      //
      yield state.copyWith(
        blocStatus: FormzStatus.pure,
      );
    }
    // else if (event is RequestTimeInitial) {
    //   yield state.copyWith(
    //     date: RequestDate.dirty(DateTime.now()),
    //     fromTime: RequestTime.dirty(
    //       TimeOfDay.fromDateTime(
    //         CommonUtils.getNearDateTime(
    //             RequestMapPickerLayoutConstants.minuteInterval),
    //       ),
    //     ),
    //     toTime: RequestTime.dirty(
    //       TimeOfDay.fromDateTime(
    //         CommonUtils.getNearDateTime(
    //             RequestMapPickerLayoutConstants.minuteInterval),
    //       ),
    //     ),
    //   );
    // }
  }

  Future<List<TimeOfDay>> _getOperatingTime() async {
    var listTimeOfday = await _collectingRequestService.getOperatingTime();
    return listTimeOfday;
  }

  RequestTimeStatus validate(
    DateTime date,
    TimeOfDay fromTime,
    TimeOfDay toTime, {
    TimeOfDay? nowtime,
    DateTime? now,
    required TimeOfDay operatingToTime,
    required TimeOfDay operatingFromTime,
  }) {
    nowtime ??= TimeOfDay.now();
    now ??= DateTime.now();

    if (date.isSameDate(now)) {
      if (CommonUtils.compareTwoTimeOfDays(fromTime, nowtime) <= 0) {
        return RequestTimeStatus.lessThanNow;
      } else if (CommonUtils.differenceTwoTimeOfDay(fromTime, nowtime) <= 15) {
        return RequestTimeStatus.notenough15fromtime;
      }
    }

    if (CommonUtils.compareTwoTimeOfDays(fromTime, toTime) >= 0) {
      return RequestTimeStatus.rangeTimeBetweenTwonotenough;
    }
    if (fromTime.isLargeThan(operatingToTime) ||
        fromTime.isLessThan(operatingFromTime) ||
        toTime.isLargeThan(operatingToTime) ||
        toTime.isLessThan(operatingFromTime)) {
      return RequestTimeStatus.notinrangetime;
    }
    return RequestTimeStatus.valid;
  }
}
