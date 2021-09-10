import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/ui/widgets/arrow_back_button.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPFillPhoneNumberLayout extends StatelessWidget {
  const OTPFillPhoneNumberLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScaffoldMargin.w,
          vertical: 50.0.h,
        ),
        child: const BodyWidget(),
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
        ]);
  }
}

class OTPPhoneNumberWidget extends StatelessWidget {
  const OTPPhoneNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNUmber = '+84 767234215';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomText(
          text: OTPFillPhoneNumberLayoutConstants.title,
          fontSize: 44.sp,
          fontWeight: FontWeight.w400,
        ),
        CustomText(
          text: phoneNUmber,
          fontSize: 53.sp,
          fontWeight: FontWeight.w600,
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
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {},
          child: CustomText(
            text: OTPFillPhoneNumberLayoutConstants.requetsNewCode,
            fontSize: 50.sp,
          ),
        ),
      ],
    );
  }
}
