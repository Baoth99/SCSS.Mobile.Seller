part of '../signup_otp_bloc.dart';

enum TimerStatus { processed, resent, nothing }

class OTPSignupState extends Equatable {
  const OTPSignupState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.otpCode = const OTPCode.pure(),
    this.status = FormzStatus.pure,
    this.timerStatus = TimerStatus.nothing,
  });

  final PhoneNumber phoneNumber;
  final OTPCode otpCode;
  final FormzStatus status;
  final TimerStatus timerStatus;

  OTPSignupState copyWith(
      {PhoneNumber? phoneNumber,
      OTPCode? otpCode,
      FormzStatus? status,
      TimerStatus? timerStatus}) {
    return OTPSignupState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      timerStatus: timerStatus ?? this.timerStatus,
    );
  }

  @override
  List<Object> get props => [
        otpCode,
        status,
        timerStatus,
      ];
}
