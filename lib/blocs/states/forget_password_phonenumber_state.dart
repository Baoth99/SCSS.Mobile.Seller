part of '../forget_password_phonenumber_bloc.dart';

class ForgetPasswordPhoneNumberState extends Equatable {
  const ForgetPasswordPhoneNumberState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final PhoneNumber phoneNumber;
  final FormzStatus status;

  ForgetPasswordPhoneNumberState copyWith({
    PhoneNumber? phoneNumber,
    FormzStatus? status,
  }) {
    return ForgetPasswordPhoneNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        phoneNumber,
        status,
      ];
}
