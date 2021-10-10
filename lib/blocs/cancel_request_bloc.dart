import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/cancel_reason_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';

part 'states/cancel_request_state.dart';
part 'events/cancel_request_event.dart';

class CancelRequestBloc extends Bloc<CancelRequestEvent, CancelRequestState> {
  late CollectingRequestService _collectingRequestService;
  CancelRequestBloc({
    required String requestId,
    CollectingRequestService? collectingRequestService,
  }) : super(
          CancelRequestState(
            requestId: requestId,
          ),
        ) {
    _collectingRequestService =
        collectingRequestService ?? getIt.get<CollectingRequestService>();
  }

  @override
  Stream<CancelRequestState> mapEventToState(CancelRequestEvent event) async* {
    if (event is CancelReasonChanged) {
      try {
        var cancelReason = CancelReason.dirty(event.cancelReason);
        yield state.copyWith(
          cancelReason: cancelReason,
          status: Formz.validate([cancelReason]),
        );
      } catch (e) {
        print(e);
      }
    } else if (event is CancelRequestSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var cancelReason = CancelReason.dirty(state.cancelReason.value);
        yield state.copyWith(
          cancelReason: cancelReason,
          status: Formz.validate([cancelReason]),
        );

        if (state.status.isValid) {
          bool result = await _collectingRequestService.cancelRequest(
            state.requestId,
            state.cancelReason.value,
          );

          if (result) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception('cancelReason is false');
          }
        } else {
          throw Exception('cancelReason is not valid');
        }
      } catch (e) {
        print(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
