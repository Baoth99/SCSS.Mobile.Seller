import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/activity_service.dart';

part 'states/feedback_transaction_state.dart';
part 'events/feedback_transaction_event.dart';

class FeedbackTransactionBloc
    extends Bloc<FeedbackTransactionEvent, FeedbackTransactionState> {
  late ActivityService _activityService;
  FeedbackTransactionBloc({
    required String transactionId,
    required double rates,
    ActivityService? activityService,
  }) : super(
          FeedbackTransactionState(
            transactionId: transactionId,
            rate: rates,
          ),
        ) {
    _activityService = activityService ?? getIt.get<ActivityService>();
  }

  @override
  Stream<FeedbackTransactionState> mapEventToState(
      FeedbackTransactionEvent event) async* {
    if (event is FeedbackReviewChanged) {
      try {
        yield state.copyWith(
          review: event.review,
        );
      } catch (e) {
        print(e);
      }
    } else if (event is FeedbackRateChanged) {
      try {
        yield state.copyWith(
          rate: event.rate,
        );
      } catch (e) {
        print(e);
      }
    } else if (event is FeedbackTransactionSubmmited) {
      try {
        bool result = await _activityService.feedbackTransaction(
          state.transactionId,
          state.rate,
          state.review,
        );

        if (result) {
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception('feedbackAdmin is false');
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
