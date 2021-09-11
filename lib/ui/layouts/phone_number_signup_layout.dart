import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/blocs/blocs.dart';
import 'package:seller_app/ui/layouts/otp_fill_signup_layout.dart';
import 'package:seller_app/ui/widgets/arrow_back_button.dart';
import 'package:seller_app/ui/widgets/custom_button_widgets.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/utils/common_utils.dart';

class PhoneNumberSignupLayout extends StatefulWidget {
  const PhoneNumberSignupLayout({Key? key}) : super(key: key);

  @override
  _PhoneNumberSignupLayoutState createState() =>
      _PhoneNumberSignupLayoutState();
}

class _PhoneNumberSignupLayoutState extends State<PhoneNumberSignupLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: const ArrowBackIconButton(
            color: AppColors.black,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: BlocProvider<SignupBloc>(
          create: (_) => SignupBloc(),
          child: BlocListener<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state.status.isSubmissionSuccess) {
                Navigator.pop(context);

                // navigate to otp code
                Navigator.pushNamed(
                  context,
                  Routes.otpFillSignup,
                  arguments: OTPFillPhoneNumberArgument(
                    state.phoneNumber.value,
                    Symbols.vietnamCallingCode,
                  ),
                );
              }
              if (state.status.isSubmissionInProgress) {
                WidgetUtils.showCustomDialog(
                  context,
                  PhoneNumberSignupLayoutConstants.waiting,
                  PhoneNumberSignupLayoutConstants.progressIndicatorLabel,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 80.0.h,
                left: AppConstants.horizontalScaffoldMargin.w,
                right: AppConstants.horizontalScaffoldMargin.w,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        CustomText(
                          text: PhoneNumberSignupLayoutConstants.welcomeTitle,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.left,
                          fontSize: 55.sp,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 80.0.h,
                            bottom: 20.0.h,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.greyFF9098B1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17.0.r),
                                    ),
                                  ),
                                  child: CountryCodePicker(
                                    initialSelection: Symbols.vietnamISOCode,
                                    favorite: <String>[
                                      Symbols.vietnamCallingCode,
                                      Symbols.vietnamISOCode,
                                    ],
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    enabled: false,
                                    textStyle: TextStyle(
                                      fontSize: 40.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 25.0.w,
                                    ),
                                    child: PhoneNumberInput(
                                      onSubmit: _onSubmit,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) => Visibility(
                            child: Container(
                              width: double.infinity,
                              child: CustomText(
                                text:
                                    PhoneNumberSignupLayoutConstants.errorText,
                                fontSize: 40.sp,
                                color: AppColors.red,
                              ),
                            ),
                            visible: state.phoneNumber.invalid,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        NextButton(
                          onSubmit: _onSubmit,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    context.read<SignupBloc>().add(
          ButtonPressedToGetOTP(),
        );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({Key? key, this.onSubmit}) : super(key: key);

  final void Function(BuildContext context)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) => CustomButton(
        text: PhoneNumberSignupLayoutConstants.next,
        onPressed: state.status.isValidated
            ? () {
                onSubmit?.call(context);
              }
            : null,
        fontSize: 55.sp,
        width: double.infinity,
        height: 130.0.h,
        color: AppColors.greenFF61C53D,
        circularBorderRadius: 17.0.r,
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  final void Function(BuildContext context)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: PhoneNumberSignupLayoutConstants.phoneNumberHint,
            hintStyle: _getPhoneNumberTextStyle(
              color: AppColors.greyFFDADADA,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 26.0.h,
              horizontal: 15.0.w,
            ),
            border: _getOutLineInputBorder(),
            focusedBorder: _getOutLineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.greyFF9098B1,
              ),
            ),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: _getPhoneNumberTextStyle(),
          onChanged: _onChanged(context),
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (value) {
            onSubmit?.call(context);
          },
        );
      },
    );
  }

  void Function(String)? _onChanged(BuildContext context) {
    return (value) => context.read<SignupBloc>().add(
          PhoneNumberChanged(phoneNumber: value),
        );
  }

  TextStyle _getPhoneNumberTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 90.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  OutlineInputBorder _getOutLineInputBorder({BorderSide? borderSide}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17.0.r),
      borderSide: borderSide ?? const BorderSide(),
    );
  }
}
