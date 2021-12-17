part of '../login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.phoneNumber = const LoginPhoneNumber.pure(),
    this.password = const PasswordLogin.pure(),
    this.status = FormzStatus.pure,
  });

  final LoginPhoneNumber phoneNumber;
  final PasswordLogin password;
  final FormzStatus status;

  LoginState copyWith({
    LoginPhoneNumber? phoneNumber,
    PasswordLogin? password,
    FormzStatus? status,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        password,
        status,
      ];
}
