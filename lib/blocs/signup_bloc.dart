import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';

part 'events/signup_event.dart';
part 'states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is PhoneNumberChanged) {
      final phoneNumber = event.phoneNumber.isEmpty
          ? PhoneNumber.pure()
          : PhoneNumber.dirty(event.phoneNumber);
      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate([phoneNumber]),
      );
    }
    if (event is ButtonPressedToGetOTP) {
      final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);

      yield state.copyWith(
        phoneNumber: phoneNumber,
        status: Formz.validate([phoneNumber]),
      );

      if (state.status.isValidated) {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        //API
        await Future<void>.delayed(
          const Duration(
            seconds: 5,
          ),
        );
        //API

        yield state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      }
    }
  }
}
