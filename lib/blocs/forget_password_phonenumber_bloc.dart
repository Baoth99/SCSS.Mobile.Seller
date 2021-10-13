import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';

part 'states/forget_password_phonenumber_state.dart';
part 'events/forget_password_phonenumber_event.dart';

class ForgetPasswordPhoneNumberBloc extends Bloc<ForgetPasswordPhoneNumberEvent,
    ForgetPasswordPhoneNumberState> {
  late IdentityServerService _identityServerService;
  ForgetPasswordPhoneNumberBloc({
    IdentityServerService? identityServerService,
  }) : super(
          const ForgetPasswordPhoneNumberState(),
        ) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  @override
  Stream<ForgetPasswordPhoneNumberState> mapEventToState(
      ForgetPasswordPhoneNumberEvent event) async* {
    if (event is ForgetPasswordPhoneNumberChanged) {
      try {
        var phoneNumber = PhoneNumber.dirty(event.phoneNumber);
        yield state.copyWith(
          phoneNumber: phoneNumber,
          status: Formz.validate([phoneNumber]),
        );
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ForgetPasswordPhoneNumberSubmmited) {}
  }
}
