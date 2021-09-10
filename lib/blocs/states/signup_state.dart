part of '../signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final PhoneNumber phoneNumber;
  final FormzStatus status;

  SignupState copyWith({PhoneNumber? phoneNumber, FormzStatus? status}) {
    return SignupState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        phoneNumber,
        status,
      ];
}
