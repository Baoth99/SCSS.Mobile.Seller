import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/ui/widgets/custom_border_text_form_field_widget.dart';
import 'package:seller_app/ui/widgets/custom_button_widgets.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          leading: IconButton(
            icon: Icon(
              AppIcons.arrowBack,
              color: AppColors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(
            bottom: 80.0.h,
            left: 48.0.w,
            right: 48.0.w,
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
                      margin: EdgeInsets.symmetric(
                        vertical: 80.0.h,
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
                              child: CustomBorderTextFormField(
                                hintText: PhoneNumberSignupLayoutConstants
                                    .phoneNumberHint,
                                hintStyle: _getPhoneNumberTextStyle(
                                  color: AppColors.greyFFDADADA,
                                ),
                                style: _getPhoneNumberTextStyle(),
                                commonColor: AppColors.greyFF9098B1,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 26.0.h,
                                  horizontal: 15.0.w,
                                ),
                                cirularBorderRadius: 17.0.r,
                                padding: EdgeInsets.only(
                                  left: 25.0.w,
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CustomButton(
                      text: PhoneNumberSignupLayoutConstants.next,
                      onPressed: () {},
                      fontSize: 55.sp,
                      width: double.infinity,
                      height: 130.0.h,
                      color: AppColors.greenFF61C53D,
                      circularBorderRadius: 17.0.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getPhoneNumberTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 90.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
