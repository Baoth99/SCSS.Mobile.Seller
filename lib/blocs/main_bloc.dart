import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';

part 'states/main_state.dart';
part 'events/main_event.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({
    CollectingRequestService? collectingRequestService,
  }) : super(MainState()) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }
  late CollectingRequestService _collectingRequestService;
  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is MainBarItemTapped) {
      yield state.copyWith(screenIndex: event.index);
    } else if (event is MainInitial) {
      add(const MainBarItemTapped(0));
    } else if (event is MainCheckFullRequest) {
      try {
        yield state.copyWith(
          statusCreateRequest: FormzStatus.submissionInProgress,
        );
        var isRequestFull = await _collectingRequestService.getRequestAbility();
        yield state.copyWith(
          isRequestFull: isRequestFull,
          statusCreateRequest: FormzStatus.submissionSuccess,
        );
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          statusCreateRequest: FormzStatus.submissionFailure,
        );
      }
      yield state.copyWith(
        statusCreateRequest: FormzStatus.pure,
      );
    } else if (event is MainActivityChanged) {
      yield state.copyWith(activityIndex: event.index);
    }
  }
}
