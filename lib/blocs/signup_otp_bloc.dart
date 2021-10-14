import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_function.dart';

part 'events/signup_otp_event.dart';
part 'states/signup_otp_state.dart';

class SignupOTPBloc extends Bloc<OTPSignupEvent, OTPSignupState> {
  SignupOTPBloc({IdentityServerService? identityServerService})
      : super(const OTPSignupState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late IdentityServerService _identityServerService;
  @override
  Stream<OTPSignupState> mapEventToState(OTPSignupEvent event) async* {
    if (event is OTPSignupInitital) {
      var newState = state.copyWith(
        phoneNumber: PhoneNumber.pure(
          event.phoneNumber,
        ),
      );

      yield newState;
    } else if (event is OTPCodeChanged) {
      OTPCode otpCode = event.otpCode.isEmpty
          ? const OTPCode.pure()
          : OTPCode.dirty(event.otpCode);
      var newState = state.copyWith(
        otpCode: otpCode,
        status: Formz.validate([otpCode]),
      );

      yield newState;
    } else if (event is OTPCodeSubmitted) {
      try {
        if (state.status.isValidated) {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var token = await futureAppDuration(
            _identityServerService.confirmOTPRegister(
              state.phoneNumber.value,
              state.otpCode.value,
            ),
          );

          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            token: token,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is OTPResendPressed) {
      try {
        if (state.status.isInvalid ||
            state.status.isPure ||
            state.status.isInvalid) {
          yield state.copyWith(
            timerStatus: TimerStatus.processed,
          );

          var result = await futureAppDuration(
            _identityServerService.sendingOTPRegister(state.phoneNumber.value),
          );
          //

          if (result) {
            yield state.copyWith(
              timerStatus: TimerStatus.resent,
            );
          }
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          timerStatus: TimerStatus.error,
        );
      }
      yield state.copyWith(
        timerStatus: TimerStatus.nothing,
      );
    }
  }
}
