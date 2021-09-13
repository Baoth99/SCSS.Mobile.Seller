import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'events/signup_otp_event.dart';
part 'states/signup_otp_state.dart';

class SignupOTPBloc extends Bloc<OTPSignupEvent, OTPSignupState> {
  SignupOTPBloc() : super(const OTPSignupState());

  @override
  Stream<OTPSignupState> mapEventToState(OTPSignupEvent event) async* {
    if (event is OTPSignupInitital) {
      var newState = state.copyWith(
        phoneNumber: PhoneNumber.pure(
          CommonUtils.concatString(<String>[
            event.phoneNumber,
            event.dialingCode,
          ]),
        ),
      );

      yield newState;
    } else if (event is OTPCodeChanged) {
      if (!(state.status.isSubmissionInProgress ||
          state.status.isSubmissionSuccess)) {
        OTPCode otpCode = event.otpCode.isEmpty
            ? const OTPCode.pure()
            : OTPCode.dirty(event.otpCode);
        var newState = state.copyWith(
          otpCode: otpCode,
          status: Formz.validate([otpCode]),
        );

        yield newState;
      }
    } else if (event is OTPCodeSubmitted) {
      OTPCode otpCode = OTPCode.dirty(state.otpCode.value);

      // yield for changing status of state
      yield state.copyWith(
        otpCode: otpCode,
        status: Formz.validate([otpCode]),
      );

      // yield for listener
      if (state.status.isValidated) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        //API
        await CommonTest.delay();
        //API

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      }
    } else if (event is OTPResendPressed) {
      //TODO: may be have the "isFailure" after integrate API
      if (state.status.isInvalid ||
          state.status.isPure ||
          state.status.isInvalid) {
        yield state.copyWith(
          timerStatus: TimerStatus.processed,
        );

        //TODO: API
        await CommonTest.delay();
        //

        yield state.copyWith(
          timerStatus: TimerStatus.resent,
        );

        yield state.copyWith(
          timerStatus: TimerStatus.nothing,
        );
      }
    }
  }
}
