import 'package:equatable/equatable.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:bloc/bloc.dart';

part 'events/signup_event.dart';
part 'states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState());

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is PhoneNumberChanged) {
      final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
      yield state.copyWith(
        phoneNumber:
            event.phoneNumber.isEmpty ? PhoneNumber.pure() : phoneNumber,
      );
    }
  }
}
