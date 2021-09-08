import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                LoginWidgetConstants.loginLogoImagePath,
                fit: BoxFit.contain,
                height: 270.h,
              ),
            ),
            Text(
              LoginWidgetConstants.loginToContinue,
              style: TextStyle(color: AppColors.greyFF9098B1, fontSize: 35.sp),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 55.h,
                    ),
                    child: InputField(
                      labelText: LoginWidgetConstants.phoneNumber,
                      commonColor: AppColors.greenFF61C53D,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 30.h,
                    ),
                    child: InputField(
                      labelText: LoginWidgetConstants.password,
                      commonColor: AppColors.greenFF61C53D,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 55.h,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 37.w),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.greenFF61C53D,
                        minimumSize: Size(
                          double.infinity,
                          130.h,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(LoginWidgetConstants.login),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                LoginWidgetConstants.forgetPassword,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 35.w,
                vertical: 150.h,
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
                    child: Text(
                      LoginWidgetConstants.or,
                      style: TextStyle(
                        color: AppColors.greyFF9098B1,
                        fontSize: 33.sp,
                      ),
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 200.w,
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(LoginWidgetConstants.createNewAccount),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.orangeFFF5670A,
                  minimumSize: Size(double.infinity, 80.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.labelText,
    required this.commonColor,
    this.keyboardType = TextInputType.multiline,
    this.obscureText = false,
    this.inputFormatters = const [],
  }) : super(key: key);
  final String labelText;
  final Color commonColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 35.0.w,
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        inputFormatters: widget.inputFormatters,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            15.0.r,
          )),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.commonColor),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 35.0.w,
            vertical: 42.0.h,
          ),
        ),
      ),
    );
  }
}
