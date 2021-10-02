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
  final initialAbstractPage = 2;
  final sizeList = 10;
  @override
  Stream<ActivityListState> mapEventToState(ActivityListEvent event) async* {
    if (event is ActivityListInitial) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          status: ActivityListStatus.progress,
        );

        var listActivity = await getListActivityByStatus(pageSize, 1);

        yield state.copyWith(
          status: ActivityListStatus.completed,
          listActivity: listActivity,
          page: listActivity.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          status: ActivityListStatus.error,
        );
      }
    } else if (event is ActivityListRefresh) {
      int pageSize = initialAbstractPage * sizeList;

      try {
        yield state.copyWith(
          refreshStatus: RefreshStatus.refreshing,
        );
        var listActivity = await getListActivityByStatus(pageSize, 1);

        yield state.copyWith(
          refreshStatus: RefreshStatus.completed,
          listActivity: listActivity,
          page: listActivity.isNotEmpty ? initialAbstractPage : 0,
        );
      } catch (e) {
        yield state.copyWith(
          refreshStatus: RefreshStatus.failed,
        );
      }
    } else if (event is ActivityListLoading) {
      try {
        yield state.copyWith(
          loadStatus: LoadStatus.loading,
        );
        var listActivity =
            await getListActivityByStatus(sizeList, state.page + 1);
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
          listActivity: state.listActivity..addAll(listActivity),
          page: listActivity.isNotEmpty ? state.page + 1 : state.page,
        );
      } catch (e) {
        yield state.copyWith(
          loadStatus: LoadStatus.idle,
        );
      }
    }
  }

  Future<List<Activity>> getListActivityByStatus(int size, int page) async {
    return await futureAppDuration<List<Activity>>(
      _activityService.getListActivityByStatus(
          state.activityStatus, size, page),
    );
  }
}
