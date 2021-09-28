import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePasswordEditLayout extends StatelessWidget {
  const ProfilePasswordEditLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomText(
          text: 'Đổi mật khẩu',
        ),
      ),
      body: const CommonMarginContainer(
        child: SingleChildScrollView(
          child: ProfilePasswordEditBody(),
        ),
      ),
    );
  }
}

class ProfilePasswordEditBody extends StatelessWidget {
  const ProfilePasswordEditBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        getSizedbox(),
        input(
          hintText: 'Mật khẩu hiện tại',
          obscureText: true,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.visibilityOff,
              size: 58.sp,
            ),
          ),
        ),
        getSizedbox(),
        input(
          hintText: 'Mật khẩu mới',
          obscureText: true,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.visibilityOff,
              size: 58.sp,
            ),
          ),
        ),
        getSizedbox(),
        input(
          hintText: 'Nhập lại mật khẩu mới',
          obscureText: true,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              AppIcons.visibilityOff,
              size: 58.sp,
            ),
          ),
        ),
        getSizedbox(),
        submmitedButton(
          'Đổi mật khẩu',
          AppColors.greenFF61C53D,
          () {},
        ),
        getSizedbox(),
        submmitedButton(
          'Hủy',
          AppColors.orangeFFF5670A,
          () {},
        ),
      ],
    );
  }

  Widget getSizedbox() {
    return SizedBox(
      height: 32.h,
    );
  }

  Widget input({
    String? labelText,
    String? hintText,
    bool? obscureText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onChanged,
    Widget? suffixIcon,
    String? errorText,
    String? initialValue,
    bool? enabled,
  }) {
    return TextFormField(
      style: TextStyle(fontSize: 50.sp),
      enabled: enabled,
      initialValue: initialValue,
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

  Widget submmitedButton(String text, Color color, void Function()? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: Size(
          double.infinity,
          WidgetConstants.buttonCommonHeight.h,
        ),
      ),
      onPressed: onPressed,
      child: CustomText(
        text: text,
        fontSize: WidgetConstants.buttonCommonFrontSize.sp,
        fontWeight: WidgetConstants.buttonCommonFrontWeight,
      ),
    );
  }
}
