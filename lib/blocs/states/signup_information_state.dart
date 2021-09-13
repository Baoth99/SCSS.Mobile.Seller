part of '../signup_information_bloc.dart';

class SignupInformationState extends Equatable {
  const SignupInformationState({
    this.name = const Name.pure(),
    this.gender = Gender.male,
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Name name;
  final Gender gender;
  final Password password;
  final RepeatPassword repeatPassword;
  final FormzStatus status;

  SignupInformationState copyWith({
    Name? name,
    Gender? gender,
    Password? password,
    RepeatPassword? repeatPassword,
    FormzStatus? status,
  }) {
    return SignupInformationState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        name,
        gender,
        password,
        repeatPassword,
        status,
      ];
}
