import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/activity_service.dart';

part 'events/home_event.dart';
part 'states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late ActivityService _activityService;
  HomeBloc({ActivityService? activityService}) : super(const HomeState()) {
    _activityService = activityService ?? getIt.get<ActivityService>();
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeFetch) {
      try {
        if (state.apiState == APIFetchState.idle &&
            !state.status.isSubmissionInProgress &&
            !state.status.isPure) {
          yield state.copyWith(
            apiState: APIFetchState.fetching,
            activity: state.activity,
          );
          var activity = await _activityService.getNearestApprovedRequets();

          yield state.copyWith(
            apiState: APIFetchState.idle,
            activity: activity,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          apiState: APIFetchState.idle,
          activity: state.activity,
        );
      }
    } else if (event is HomeInitial) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var activity = await _activityService.getNearestApprovedRequets();

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
          activity: activity,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
