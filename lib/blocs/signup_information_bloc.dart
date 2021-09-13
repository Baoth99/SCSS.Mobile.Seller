import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:seller_app/utils/common_utils.dart';
part 'states/signup_information_state.dart';
part 'events/signup_information_event.dart';

class SignupInformationBloc
    extends Bloc<SignupInformationEvent, SignupInformationState> {
  SignupInformationBloc() : super(const SignupInformationState());

  @override
  Stream<SignupInformationState> mapEventToState(
      SignupInformationEvent event) async* {
    if (event is SignupInformationNameChanged) {
      var name = Name.dirty(
        event.name,
      );
      yield state.copyWith(
        name: name,
        status: Formz.validate(
          [
            name,
            state.password,
            state.repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationGenderChanged) {
      yield state.copyWith(
        gender: event.gender,
      );
    } else if (event is SignupInformationPasswordChanged) {
      var password = Password.dirty(
        password: state.password.value.copyWith(
          value: event.password,
        ),
      );

      var repeatPassword = state.repeatPassword.pure
          ? RepeatPassword.pure(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            )
          : RepeatPassword.dirty(
              password: state.repeatPassword.value,
              currentPassword: event.password,
            );

      yield state.copyWith(
        password: password,
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            state.name,
            password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationRepeatPasswordChanged) {
      var repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: event.repeatPassword,
        ),
        currentPassword: state.password.value.value,
      );
      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate(
          [
            state.name,
            state.password,
            repeatPassword,
          ],
        ),
      );
    } else if (event is SignupInformationPasswordShowOrHide) {
      Password password;
      var commonPassword = state.password.value.copyWith(
        isHide: !state.password.value.isHide,
      );

      if (state.password.pure) {
        password = Password.pure(
          password: commonPassword,
        );
      } else {
        password = Password.dirty(
          password: commonPassword,
        );
      }

      yield state.copyWith(
        password: password,
      );
    } else if (event is SignupInformationRepeatPasswordShowOrHide) {
      RepeatPassword password;
      var commonPassword = state.repeatPassword.value.copyWith(
        isHide: !state.repeatPassword.value.isHide,
      );

      if (state.repeatPassword.pure) {
        password = RepeatPassword.pure(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      } else {
        password = RepeatPassword.dirty(
          password: commonPassword,
          currentPassword: state.password.value.value,
        );
      }

      yield state.copyWith(
        repeatPassword: password,
      );
    } else if (event is SignupInformationSubmmited) {
      Name name = Name.dirty(state.name.value);
      Gender gender = state.gender;
      Password password = Password.dirty(
        password: state.password.value.copyWith(
          value: state.password.value.value,
        ),
      );
      RepeatPassword repeatPassword = RepeatPassword.dirty(
        password: state.repeatPassword.value.copyWith(
          value: state.repeatPassword.value.value,
        ),
        currentPassword: password.value.value,
      );

      yield state.copyWith(
        name: name,
        gender: gender,
        password: password,
        repeatPassword: repeatPassword,
      );

      //TODO: may be have failue
      if (state.status.isValid) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        //TODO: API
        await CommonTest.delay();
        //TODO: delete print
        print(
            'Name: ${state.name.value} , Gender: ${state.gender}, Password: ${state.password.value.value}, RepeatPassword: ${state.repeatPassword.value.value}');
        //

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      }
    }
  }
}
