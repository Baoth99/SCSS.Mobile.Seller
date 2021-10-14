import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_function.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'events/signup_event.dart';
part 'states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  late IdentityServerService _identityServerService;
  SignupBloc({
    IdentityServerService? identityServerService,
  }) : super(const SignupState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is PhoneNumberChanged) {
      try {
        var phoneNumber = PhoneNumber.dirty(event.phoneNumber);
        yield state.copyWith(
          phoneNumber: phoneNumber,
          status: Formz.validate([phoneNumber]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ButtonPressedToGetOTP) {
      try {
        final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);

        yield state.copyWith(
          phoneNumber: phoneNumber,
          status: Formz.validate([phoneNumber]),
        );

        if (state.status.isValidated) {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var result = await futureAppDuration(
            _identityServerService.sendingOTPRegister(phoneNumber.value),
          );

          if (result) {
            var strphoneNumber = CommonUtils.addZeroBeforePhoneNumber(
              state.phoneNumber.value,
            );

            yield state.copyWith(
              phoneNumber: PhoneNumber.dirty(strphoneNumber),
            );
          }

          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            isSuccessful: result,
          );
        }
      } catch (e) {
        AppLog.error(e);
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
