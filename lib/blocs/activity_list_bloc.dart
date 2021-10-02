import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/activity_service.dart';
import 'package:seller_app/utils/common_function.dart';
part 'events/activity_list_event.dart';
part 'states/activity_list_state.dart';

class ActivityListBloc extends Bloc<ActivityListEvent, ActivityListState> {
  ActivityListBloc({
    required int status,
    ActivityService? requestService,
  }) : super(
          ActivityListState(activityStatus: status),
        ) {
    _activityService = requestService ?? getIt.get<ActivityService>();
  }
  late ActivityService _activityService;
  @override
  Stream<ActivityListState> mapEventToState(ActivityListEvent event) async* {
    if (event is ActivityListRetreived) {
      try {
        yield state.copyWith(
          status: ActivityListStatus.progress,
        );

        var listActivity = await getListActivityByStatus();

        yield state.copyWith(
          status: ActivityListStatus.completed,
          listActivity: listActivity,
        );
      } catch (e) {
        yield state.copyWith(
          status: ActivityListStatus.error,
        );
      }
    } else if (event is ActivityListInitial) {
      add(ActivityListRetreived());
    } else if (event is ActivityListRefresh) {
      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listActivity = await getListActivityByStatus();

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listActivity: listActivity,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    }
  }

  Future<List<Activity>> getListActivityByStatus() async {
    return await futureAppDuration<List<Activity>>(
      _activityService.getListActivityByStatus(state.activityStatus),
    );
  }
}
