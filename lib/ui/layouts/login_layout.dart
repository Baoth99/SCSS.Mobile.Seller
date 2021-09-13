import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/ui/widgets/custom_button_widgets.dart';
import 'package:seller_app/ui/widgets/custom_border_text_form_field_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_button_widget.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(
          top: 200.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: 100.h,
              ),
              child: Image.asset(
                LoginLayoutConstants.loginLogoImagePath,
                fit: BoxFit.contain,
                height: 270.h,
              ),
            ),
            CustomText(
              text: LoginLayoutConstants.loginToContinue,
              color: AppColors.greyFF9098B1,
              fontSize: 35.sp,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 55.h,
                    ),
                    child: CustomBorderTextFormField(
                      style: _getInputFieldTextStyle(),
                      labelText: LoginLayoutConstants.phoneNumber,
                      commonColor: AppColors.greenFF61C53D,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      padding: EdgeInsets.symmetric(
                        horizontal: 60.0.w,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 45.0.w,
                        vertical: 42.0.h,
                      ),
                      cirularBorderRadius: 15.0.r,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 30.h,
                    ),
                    child: CustomBorderTextFormField(
                      style: _getInputFieldTextStyle(),
                      labelText: LoginLayoutConstants.password,
                      commonColor: AppColors.greenFF61C53D,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: 60.0.w,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 45.0.w,
                        vertical: 42.0.h,
                      ),
                      cirularBorderRadius: 15.0.r,
                    ),
                  ),
                  CustomButton(
                    text: LoginLayoutConstants.login,
                    fontSize: 45.sp,
                    onPressed: () {},
                    color: AppColors.greenFF61C53D,
                    height: 130.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                      vertical: 50.0.h,
                    ),
                    circularBorderRadius: 15.0.r,
                  ),
                ],
              ),
            ),
            CustomTextButton(
              text: LoginLayoutConstants.forgetPassword,
              onPressed: () {},
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 35.w,
                vertical: 100.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      thickness: 3.h,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: CustomText(
                      text: LoginLayoutConstants.or,
                      color: AppColors.greyFF9098B1,
                      fontSize: 33.sp,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 3.h,
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              text: LoginLayoutConstants.signup,
              onPressed: () {
                _navigateToSignup(context);
              },
              fontSize: 44.sp,
              color: AppColors.orangeFFF5670A,
              width: double.infinity,
              height: 100.h,
              padding: EdgeInsets.symmetric(
                horizontal: 180.w,
              ),
              circularBorderRadius: 15.0.r,
            ),
          ],
        ),
      ),
    );
  }

  // Navigate the screen to first screen of signup screen
  void _navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, Routes.signupPhoneNumber);
  }

  TextStyle _getInputFieldTextStyle() {
    return TextStyle(
      fontSize: 52.sp,
      fontWeight: FontWeight.w400,
    );
  }
}
