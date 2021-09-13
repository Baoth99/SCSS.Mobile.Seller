import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'states/login_state.dart';
part 'events/login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPhoneNumberChanged) {
      var phoneNumber = LoginPhoneNumber.dirty(event.phoneNumber);
      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate(
          [
            phoneNumber,
            state.password,
          ],
        ),
      );
    } else if (event is LoginPasswordChanged) {
      var password = Password.dirty(
        password: state.password.value.copyWith(
          value: event.password,
        ),
      );

      yield state.copyWith(
        password: password,
        status: Formz.validate(
          [
            state.phoneNumber,
            password,
          ],
        ),
      );
    } else if (event is LoginButtonSubmmited) {
      var phoneNumber = LoginPhoneNumber.dirty(state.phoneNumber.value);
      var password = Password.dirty(
        password: state.password.value.copyWith(
          value: state.password.value.value,
        ),
      );
      yield state.copyWith(
        phoneNumber: phoneNumber,
        password: password,
        status: Formz.validate(
          [
            phoneNumber,
            password,
          ],
        ),
      );

      if (state.status.isValid) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        //TODO: api LOGIN, AUTHENTICATE
        await CommonTest.delay();
        //TODO: api LOGIN, AUTHENTICATE

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      }
    }
  }
}
