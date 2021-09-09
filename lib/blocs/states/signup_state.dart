part of '../signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({
    this.phoneNumber = const PhoneNumber.pure(),
  });

  final PhoneNumber phoneNumber;

  SignupState copyWith({PhoneNumber? phoneNumber}) {
    return SignupState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [this.phoneNumber];
}
