import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/signup_information_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

//TODO: COOL_ALERT don't have null safety because map box
import 'package:cool_alert/cool_alert.dart';

class SignupInformationLayout extends StatelessWidget {
  const SignupInformationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: AppColors.black,
      ),
      body: BlocProvider<SignupInformationBloc>(
          create: (_) => SignupInformationBloc(),
          child: BlocListener<SignupInformationBloc, SignupInformationState>(
            listener: (context, state) {
              if (state.status.isSubmissionInProgress) {
                FunctionalWidgets.showCustomDialog(
                  context,
                  SignupInformationLayoutConstants.waiting,
                );
              }

              if (state.status.isSubmissionSuccess) {
                Navigator.of(context).popUntil(
                  (route) => route.settings.name == Routes.signupInformation,
                );

                FunctionalWidgets.showCoolAlert(
                  context: context,
                  type: CoolAlertType.success,
                  title: SignupInformationLayoutConstants.titleDialog,
                  text: SignupInformationLayoutConstants.success,
                  confirmBtnColor: AppColors.greenFF61C53D,
                  confirmBtnText:
                      SignupInformationLayoutConstants.btnDialogName,
                  confirmBtnTapRoute: Routes.login,
                );
              }
            },
            child: const _Body(),
          )),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScaffoldMargin.w,
      ),
      child: Column(
        children: <Widget>[
          const _Title(),
          Expanded(
              child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                ),
                child: const _Form(),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _InputContainer extends StatelessWidget {
  const _InputContainer({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 19.0.h),
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CustomText(
        text: SignupInformationLayoutConstants.title,
        fontSize: 65.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: 30.0.h,
            bottom: 25.0.h,
          ),
          child: const _FormInputs(),
        ),
        const _SubmmitedButton(),
      ],
    );
  }
}

class _FormInputs extends StatelessWidget {
  const _FormInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _InputContainer(
          child: BlocBuilder<SignupInformationBloc, SignupInformationState>(
            buildWhen: (previous, current) =>
                previous.name.status != current.name.status,
            builder: (context, state) {
              return _TextField(
                labelText: SignupInformationLayoutConstants.labelName,
                hintText: SignupInformationLayoutConstants.hintName,
                onChanged: _onNameChanged(context),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                errorText: state.name.invalid
                    ? SignupInformationLayoutConstants.errorName
                    : null,
              );
            },
          ),
        ),
        const _InputContainer(
          child: _GenderInput(),
        ),
        _InputContainer(
          child: BlocBuilder<SignupInformationBloc, SignupInformationState>(
            buildWhen: (previous, current) =>
                previous.password.status != current.password.status ||
                previous.password.value.isHide != current.password.value.isHide,
            builder: (context, state) {
              return _TextFieldPassword(
                labelText: SignupInformationLayoutConstants.labelPassword,
                hintText: SignupInformationLayoutConstants.hintPassword,
                onChanged: _onPasswordChanged(context),
                textInputAction: TextInputAction.next,
                errorText: state.password.invalid
                    ? SignupInformationLayoutConstants.errorPassword
                    : null,
                isHide: state.password.value.isHide,
                onPasswordShowHide: _onPasswordShowHide(context),
              );
            },
          ),
        ),
        _InputContainer(
          child: BlocBuilder<SignupInformationBloc, SignupInformationState>(
            buildWhen: (previous, current) =>
                previous.repeatPassword.status !=
                    current.repeatPassword.status ||
                previous.repeatPassword.value.isHide !=
                    current.repeatPassword.value.isHide,
            builder: (context, state) {
              return _TextFieldPassword(
                labelText: SignupInformationLayoutConstants.labelRepeatPassword,
                hintText: SignupInformationLayoutConstants.hintRepeatPassword,
                onChanged: _onRepeatPasswordChanged(context),
                textInputAction: TextInputAction.go,
                errorText: state.repeatPassword.invalid
                    ? SignupInformationLayoutConstants.errorRepeatPassword
                    : null,
                isHide: state.repeatPassword.value.isHide,
                onPasswordShowHide: _onRepeatPasswordShowHide(context),
              );
            },
          ),
        ),
      ],
    );
  }

  void Function() Function(BuildContext context) _onRepeatPasswordShowHide(
      BuildContext context) {
    return (context) => () {
          context.read<SignupInformationBloc>().add(
                SignupInformationRepeatPasswordShowOrHide(),
              );
        };
  }

  void Function() Function(BuildContext context) _onPasswordShowHide(
      BuildContext context) {
    return (context) => () {
          context.read<SignupInformationBloc>().add(
                SignupInformationPasswordShowOrHide(),
              );
        };
  }

  void Function(String) _onNameChanged(BuildContext context) {
    return (value) {
      context.read<SignupInformationBloc>().add(
            SignupInformationNameChanged(
              name: value,
            ),
          );
    };
  }

  void Function(String) _onPasswordChanged(BuildContext context) {
    return (value) {
      context.read<SignupInformationBloc>().add(
            SignupInformationPasswordChanged(password: value),
          );
    };
  }

  void Function(String) _onRepeatPasswordChanged(BuildContext context) {
    return (value) {
      context.read<SignupInformationBloc>().add(
            SignupInformationRepeatPasswordChanged(repeatPassword: value),
          );
    };
  }
}

class _TextFieldPassword extends StatelessWidget {
  const _TextFieldPassword({
    Key? key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.textInputAction,
    this.isHide = true,
    this.errorText,
    this.onPasswordShowHide,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final bool isHide;
  final String? errorText;
  final void Function() Function(BuildContext)? onPasswordShowHide;

  @override
  Widget build(BuildContext context) {
    return _TextField(
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      textInputAction: textInputAction,
      obscureText: isHide,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: IconButton(
        icon: Icon(
          (isHide ? AppIcons.visibilityOff : AppIcons.visibility),
          size: 58.sp,
        ),
        onPressed:
            onPasswordShowHide != null ? onPasswordShowHide!(context) : null,
      ),
      errorText: errorText,
    );
  }
}

class _GenderInput extends StatelessWidget {
  const _GenderInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(
              SignupInformationLayoutConstants.circularBorderRadius.r,
            ),
          ),
          child: Row(
            children: <Widget>[
              const _RadioButtonGender(
                gender: Gender.male,
                label: SignupInformationLayoutConstants.male,
              ),
              const _RadioButtonGender(
                gender: Gender.female,
                label: SignupInformationLayoutConstants.female,
              ),
            ],
          ),
        ),
        Positioned(
          top: -15.h,
          left: 24.w,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
            ),
            child: CustomText(
              text: SignupInformationLayoutConstants.labelGender,
              fontSize: 37.0.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioButtonGender extends StatelessWidget {
  const _RadioButtonGender({
    Key? key,
    required this.gender,
    required this.label,
  }) : super(key: key);

  final Gender gender;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListTile(
        title: CustomText(
          text: label,
        ),
        leading: BlocBuilder<SignupInformationBloc, SignupInformationState>(
          buildWhen: (previous, current) => previous.gender != current.gender,
          builder: (context, state) {
            return Radio<Gender>(
              activeColor: AppColors.greenFF61C53D,
              groupValue: state.gender,
              value: gender,
              onChanged: (value) {
                context.read<SignupInformationBloc>().add(
                      SignupInformationGenderChanged(
                        gender: value ?? Gender.male,
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SubmmitedButton extends StatelessWidget {
  const _SubmmitedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120.0.h,
      child: BlocBuilder<SignupInformationBloc, SignupInformationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.greenFF61C53D,
            ),
            //TODO: case failure
            onPressed: state.status.isValid ? _onPressed(context) : null,
            child: CustomText(
              text: SignupInformationLayoutConstants.labelSubmmitedButton,
              fontSize: 45.sp,
            ),
          );
        },
      ),
    );
  }

  void Function()? _onPressed(BuildContext context) {
    return () {
      context.read<SignupInformationBloc>().add(
            SignupInformationSubmmited(),
          );
    };
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.obscureText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.suffixIcon,
    this.errorText,
  }) : super(key: key);
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        errorText: errorText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            SignupInformationLayoutConstants.circularBorderRadius.r,
          ),
          borderSide: const BorderSide(
            color: AppColors.greenFF61C53D,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
