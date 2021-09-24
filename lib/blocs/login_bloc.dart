import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_utils.dart';
part 'states/login_state.dart';
part 'events/login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _identityServerService = getIt.get<IdentityServerService>();

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
        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          // cal API
          var response = await _identityServerService.getToken(
            state.phoneNumber.value,
            state.password.value.value,
          );

          if (response.accessToken != null && response.refreshToken != null) {
            if (response.accessToken!.isNotEmpty &&
                response.refreshToken!.isNotEmpty) {
              // save to share preferences
              var accessResult = await SharedPreferenceUtils.setString(
                  APIKeyConstants.accessToken, response.accessToken!);
              var refreshResult = await SharedPreferenceUtils.setString(
                  APIKeyConstants.refreshToken, response.refreshToken!);

              if (accessResult && refreshResult) {
                // generate satus success
                yield state.copyWith(
                  status: FormzStatus.submissionSuccess,
                );
              } else {
                throw Exception();
              }
            } else if (response.accessToken!.isEmpty &&
                response.refreshToken!.isEmpty) {
              yield state.copyWith(
                phoneNumber: const LoginPhoneNumber.pure(),
                password: const Password.pure(),
                status: FormzStatus.invalid,
              );
            } else {
              throw Exception();
            }
          } else {
            throw Exception();
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
}
