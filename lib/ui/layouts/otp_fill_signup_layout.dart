import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/blocs.dart';
import 'package:seller_app/ui/widgets/arrow_back_button.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:formz/formz.dart';

class OTPFillPhoneNumberArgument {
  OTPFillPhoneNumberArgument(
    this.dialingCode,
    this.phoneNumber,
  );

  final String dialingCode;
  final String phoneNumber;
}

class OTPFillPhoneNumberLayout extends StatelessWidget {
  const OTPFillPhoneNumberLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as OTPFillPhoneNumberArgument?;

    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocProvider<SignupOTPBloc>(
        create: (_) => SignupOTPBloc()
          ..add(
            OTPSignupInitital(
              dialingCode: args?.dialingCode ?? Symbols.empty,
              phoneNumber: args?.phoneNumber ?? Symbols.empty,
            ),
          ),
        child: BlocListener<SignupOTPBloc, OTPSignupState>(
          listener: (context, state) {
            if (state.status.isValid) {
              context.read<SignupOTPBloc>().add(
                    OTPCodeSubmitted(),
                  );
            }

            if (state.status.isSubmissionInProgress) {
              WidgetUtils.showCustomDialog(
                context,
                OTPFillPhoneNumberLayoutConstants.checking,
                OTPFillPhoneNumberLayoutConstants.checkingProgressIndicator,
              );
            }

            if (state.status.isSubmissionSuccess) {
              Navigator.pop(context);
            }

            if (state.timerStatus == TimerStatus.resent) {
              Navigator.pop(context);
            }

            if (state.timerStatus == TimerStatus.processed) {
              WidgetUtils.showCustomDialog(
                context,
                OTPFillPhoneNumberLayoutConstants.resendOTP,
                OTPFillPhoneNumberLayoutConstants.resendOTPProgressIndicator,
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScaffoldMargin.w,
              vertical: 50.0.h,
            ),
            child: const BodyWidget(),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: const ArrowBackIconButton(
        color: AppColors.black,
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const OTPPhoneNumberWidget(),
        const Expanded(
          child: BottomBody(),
        ),
      ],
    );
  }
}

class OTPPhoneNumberWidget extends StatelessWidget {
  const OTPPhoneNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomText(
          text: OTPFillPhoneNumberLayoutConstants.title,
          fontSize: 44.sp,
          fontWeight: FontWeight.w400,
        ),
        BlocBuilder<SignupOTPBloc, OTPSignupState>(
          builder: (context, state) => CustomText(
            text: state.phoneNumber.value,
            fontSize: 53.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const OTPInput(),
      ],
    );
  }
}

class OTPInput extends StatelessWidget {
  const OTPInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onChanged(context),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: OTPFillPhoneNumberLayoutConstants.inputLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      style: getFontStyle(
        AppColors.blackBB000000,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: OTPFillPhoneNumberLayoutConstants.hintText,
        hintStyle: getFontStyle(
          AppColors.greyFFDADADA,
        ),
      ),
      textInputAction: TextInputAction.go,
    );
  }

  void Function(String value)? _onChanged(BuildContext context) {
    return (value) {
      if (value.length <= Others.otpLength) {
        context.read<SignupOTPBloc>().add(
              OTPCodeChanged(otpCode: value),
            );
      }
    };
  }

  TextStyle getFontStyle(Color? color) {
    return TextStyle(
      color: color,
      fontSize: 95.sp,
      fontWeight: FontWeight.w700,
    );
  }
}

class BottomBody extends StatelessWidget {
  const BottomBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: CustomText(
            text: OTPFillPhoneNumberLayoutConstants.notHaveCode,
            fontSize: 50.sp,
          ),
        ),
        const RequestCodeButton(),
      ],
    );
  }
}

class RequestCodeButton extends StatefulWidget {
  const RequestCodeButton({Key? key}) : super(key: key);

  @override
  _RequestCodeButtonState createState() => _RequestCodeButtonState();
}

class _RequestCodeButtonState extends State<RequestCodeButton> {
  Timer? _timer;
  int _start = OTPFillPhoneNumberLayoutConstants.countdown;
  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(RequestCodeButton oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if(oldWidget.in != widget.initialValue) {
  //    _setTimer();
  //  }
  // }

  void _startTimer() {
    enableButton = false;
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _timer = null;
            enableButton = true;
          } else {
            _start -= 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: enableButton
          ? () {
              if (_timer == null && _start <= 0) {
                _timer?.cancel();
                _timer = null;

                context.read<SignupOTPBloc>().add(OTPResendPressed());

                _start = OTPFillPhoneNumberLayoutConstants.countdown;
                _startTimer();
              }
            }
          : null,
      child: CustomText(
        text: OTPFillPhoneNumberLayoutConstants.requetsNewCode.replaceFirst(
          OTPFillPhoneNumberLayoutConstants.replacedSecondVar,
          CommonUtils.toStringPadleft(_start, 2),
        ),
        fontSize: 50.sp,
      ),
    );
  }
}
