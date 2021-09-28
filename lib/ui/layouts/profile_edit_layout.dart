import 'package:flutter/material.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditLayout extends StatelessWidget {
  const ProfileEditLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        title: CustomText(
          text: 'Chỉnh sửa hồ sơ',
          fontSize: 50.sp,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const ProfileEditBody(),
    );
  }
}

class ProfileEditBody extends StatelessWidget {
  const ProfileEditBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CommonMarginContainer(
        child: Center(
          child: Column(
            children: [
              avatar(),
              inputs(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputs(BuildContext context) {
    return Column(
      children: <Widget>[
        getSizeboxcolumn(),
        input(
          labelText: 'Tên',
          hintText: 'Ít nhất 1 ký tự',
          textInputAction: TextInputAction.next,
        ),
        getSizeboxcolumn(),
        input(
          textInputAction: TextInputAction.next,
          labelText: 'Số điện thoại',
          enabled: false,
        ),
        getSizeboxcolumn(),
        input(
          textInputAction: TextInputAction.next,
          labelText: 'Địa chỉ',
          hintText: 'vd: 123 Nguyen van troi',
        ),
        getSizeboxcolumn(),
        input(
          textInputAction: TextInputAction.next,
          labelText: 'Email',
          hintText: 'vd: abc@gmail.com',
        ),
        getSizeboxcolumn(),
        const InputContainer(
          lable: 'Giới tính',
          children: [
            _RadioButtonGender(
              label: 'Nam',
              gender: Gender.male,
              value: Gender.male,
            ),
            _RadioButtonGender(
              label: 'Nữ',
              gender: Gender.female,
              value: Gender.male,
            ),
          ],
        ),
        getSizeboxcolumn(),
        InkWell(
          onTap: onTapBirthday(context),
          child: InputContainer(
            lable: 'Sinh nhật',
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 35.w,
                ),
                height: 150.h,
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: '2021/12/12',
                  fontSize: 50.sp,
                ),
              ),
            ],
          ),
        ),
        getSizeboxcolumn(),
        submmitedButton(),
      ],
    );
  }

  void Function() onTapBirthday(BuildContext context) {
    return () {
      showDatePicker(
          context: context,
          initialDate: DateTime(2019),
          firstDate: DateTime(1910),
          lastDate: DateTime.now());
    };
  }

  Widget getSizeboxcolumn() {
    return SizedBox(
      height: 40.h,
    );
  }

  Widget submmitedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.greenFF61C53D,
        minimumSize: Size(
          double.infinity,
          WidgetConstants.buttonCommonHeight.h,
        ),
      ),
      onPressed: () {},
      child: CustomText(
        text: 'Lưu',
        fontSize: WidgetConstants.buttonCommonFrontSize.sp,
        fontWeight: WidgetConstants.buttonCommonFrontWeight,
      ),
    );
  }

  Widget avatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 7,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const AvatarWidget(
            imagePath:
                'https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg',
            isMale: true,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.photo_camera,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
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
}

class InputContainer extends StatelessWidget {
  const InputContainer({
    Key? key,
    required this.lable,
    required this.children,
  }) : super(key: key);
  final String lable;
  final List<Widget> children;
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
            children: children,
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
              text: lable,
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
    required this.value,
  }) : super(key: key);

  final Gender gender;
  final String label;
  final Gender value;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListTile(
        title: CustomText(
          text: label,
        ),
        leading: Radio<Gender>(
          activeColor: AppColors.greenFF61C53D,
          groupValue: value,
          value: gender,
          onChanged: (value) {},
        ),
      ),
    );
  }
}
