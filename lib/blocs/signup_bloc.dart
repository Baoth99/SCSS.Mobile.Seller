import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'events/signup_event.dart';
part 'states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is PhoneNumberChanged) {
      final phoneNumber = event.phoneNumber.isEmpty
          ? const PhoneNumber.pure()
          : PhoneNumber.dirty(event.phoneNumber);
      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate([phoneNumber]),
      );
    } else if (event is ButtonPressedToGetOTP) {
      final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);

      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate([phoneNumber]),
      );

      if (state.status.isValidated) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        //API test
        await CommonTest.delay();
        //API test

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      }
    }
  }
}
