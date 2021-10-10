import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/feedback_admin_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/activity_service.dart';

part 'states/feedback_admin_state.dart';
part 'events/feedback_admin_event.dart';

class FeedbackAdminBloc extends Bloc<FeedbackAdminEvent, FeedbackAdminState> {
  late ActivityService _activityService;
  FeedbackAdminBloc({
    required String requestId,
    ActivityService? activityService,
  }) : super(
          FeedbackAdminState(
            requestId: requestId,
          ),
        ) {
    _activityService = activityService ?? getIt.get<ActivityService>();
  }

  @override
  Stream<FeedbackAdminState> mapEventToState(FeedbackAdminEvent event) async* {
    if (event is FeedbackAdminChanged) {
      try {
        var feedback = FeedbackAdmin.dirty(event.feedback);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );
      } catch (e) {
        print(e);
      }
    } else if (event is FeedbackAdminSubmmited) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );
        var feedback = FeedbackAdmin.dirty(state.feedbackAdmin.value);
        yield state.copyWith(
          feedbackAdmin: feedback,
          status: Formz.validate([feedback]),
        );

        if (state.status.isValid) {
          bool result = await _activityService.feedbackAdmin(
            state.requestId,
            state.feedbackAdmin.value,
          );

          if (result) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception('feedbackAdmin is false');
          }
        } else {
          throw Exception('Feedback admin is not valid');
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
