import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/profile_edit_bloc.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:formz/formz.dart';

class ProfileEditArgs {
  String name;
  String? imagePath;
  String phoneNumber;
  String address;
  String email;
  Gender gender;
  DateTime? birthdate;

  ProfileEditArgs({
    required this.name,
    required this.imagePath,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.gender,
    this.birthdate,
  });
}

class ProfileEditLayout extends StatelessWidget {
  const ProfileEditLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProfileEditArgs;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        title: CustomText(
          text: 'Thông tin tài khoản',
          fontSize: 50.sp,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => ProfileEditBloc(
          name: args.name,
          address: (args.address.compareTo(Others.NA) == 0)
              ? Symbols.empty
              : args.address,
          email: (args.email.compareTo(Others.NA) == 0)
              ? Symbols.empty
              : args.email,
          gender: args.gender,
          imagePath: args.imagePath,
          dateTime: args.birthdate,
          phoneNumber: args.phoneNumber,
        ),
        child: BlocListener<ProfileEditBloc, ProfileEditState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              FunctionalWidgets.showAwesomeDialog(
                context,
                dialogType: DialogType.SUCCES,
                title: 'Cập nhật thành công',
                desc: 'Bạn đã cập nhật thông tin cá nhân thành công',
                btnOkText: 'Đóng',
                okRoutePress: Routes.profileEdit,
              );
            }
            if (state.status.isSubmissionFailure) {
              FunctionalWidgets.showErrorSystemRouteButton(
                context,
                title: 'Cập nhật thất bại',
                route: Routes.profileEdit,
              );
            }
            if (state.status.isSubmissionInProgress) {
              CommonUtils.unfocus(context);
              FunctionalWidgets.showCustomDialog(
                context,
              );
            }
          },
          child: const ProfileEditBody(),
        ),
      ),
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
    return BlocBuilder<ProfileEditBloc, ProfileEditState>(
      builder: (context, s) {
        return Column(
          children: <Widget>[
            getSizeboxcolumn(),
            input(
              labelText: 'Tên',
              hintText: 'Ít nhất 1 ký tự',
              textInputAction: TextInputAction.next,
              initialValue: s.name.value,
              onChanged: (name) {
                context.read<ProfileEditBloc>().add(
                      ProfileEditNameChanged(name),
                    );
              },
              errorText:
                  s.name.invalid ? 'Xin hãy nhập tối thiểu 1 ký tự' : null,
            ),
            getSizeboxcolumn(),
            input(
              textInputAction: TextInputAction.next,
              labelText: 'Số điện thoại',
              enabled: false,
              initialValue: s.phoneNumber,
            ),
            getSizeboxcolumn(),
            input(
              textInputAction: TextInputAction.next,
              labelText: 'Địa chỉ',
              hintText: 'vd: 123 Nguyen van troi',
              initialValue: s.address.value,
              onChanged: (address) {
                context.read<ProfileEditBloc>().add(
                      ProfileEditAddressChanged(address),
                    );
              },
              errorText:
                  s.address.invalid ? 'Xin hãy nhập tối thiểu 1 ký tự' : null,
            ),
            getSizeboxcolumn(),
            input(
              textInputAction: TextInputAction.next,
              labelText: 'Email',
              hintText: 'vd: abc@gmail.com',
              initialValue: s.email.value,
              onChanged: (email) {
                context.read<ProfileEditBloc>().add(
                      ProfileEditEmailChanged(email),
                    );
              },
              errorText: s.email.invalid
                  ? 'Xin hãy nhập theo dạng abc@gmail.com'
                  : null,
            ),
            getSizeboxcolumn(),
            InputContainer(
              lable: 'Giới tính',
              children: [
                _RadioButtonGender(
                  label: 'Nam',
                  gender: Gender.male,
                  value: s.gender,
                ),
                _RadioButtonGender(
                  label: 'Nữ',
                  gender: Gender.female,
                  value: s.gender,
                ),
              ],
            ),
            getSizeboxcolumn(),
            InkWell(
              onTap: onTapBirthday(context, s.birthDate.value),
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
                      text: s.birthDate.value != null
                          ? CommonUtils.toStringDDMMYYY(s.birthDate.value!)
                          : '__-__-____',
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
      },
    );
  }

  void Function() onTapBirthday(BuildContext context, DateTime? birthdate) {
    return () {
      showDatePicker(
        context: context,
        initialDate: birthdate ?? DateTime.now(),
        firstDate: DateTime(1910),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value != null) {
          context
              .read<ProfileEditBloc>()
              .add(ProfileEditBirthDateChanged(value));
        }
      });
    };
  }

  Widget getSizeboxcolumn() {
    return SizedBox(
      height: 40.h,
    );
  }

  Widget submmitedButton() {
    return BlocBuilder<ProfileEditBloc, ProfileEditState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColors.greenFF01C971,
            minimumSize: Size(
              double.infinity,
              WidgetConstants.buttonCommonHeight.h,
            ),
          ),
          onPressed: state.status.isValid
              ? () {
                  context.read<ProfileEditBloc>().add(ProfileEditSubmmited());
                }
              : null,
          child: CustomText(
            text: 'Lưu',
            fontSize: WidgetConstants.buttonCommonFrontSize.sp,
            fontWeight: WidgetConstants.buttonCommonFrontWeight,
          ),
        );
      },
    );
  }

  Future<List> getMetaDataImage(String imagePath) async {
    var bearerToken = NetworkUtils.getBearerToken();
    var url = NetworkUtils.getUrlWithQueryString(
      APIServiceURI.imageGet,
      {'imageUrl': imagePath},
    );
    return [
      url,
      await bearerToken,
    ];
  }

  Widget _getAvatar(
    Gender gender, {
    File? file,
    String? url,
  }) {
    if (url != null) {
      return FutureBuilder(
        future: url.isNotEmpty
            ? getMetaDataImage(url)
            : Future.value(Symbols.empty),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data is List) {
              var image = NetworkImage(data[0], headers: {
                HttpHeaders.authorizationHeader: data[1],
              });
              return AvatarWidget(
                image: image,
                isMale: gender == Gender.male,
                width: 250,
              );
            }
          }
          return AvatarWidget(
            isMale: gender == Gender.male,
            width: 250,
          );
        },
      );
    } else if (file != null) {
      return AvatarWidget(
        image: FileImage(file),
        isMale: gender == Gender.male,
        width: 250,
      );
    }
    throw Exception();
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
      margin: EdgeInsets.symmetric(
        vertical: 40.h
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          BlocBuilder<ProfileEditBloc, ProfileEditState>(
            builder: (context, state) {
              return _getAvatar(
                state.gender,
                url: state.imagePath ?? Symbols.empty,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            height: 100.h,
            child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                    size: 50.sp,
                  ),
                  onPressed: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      var path = image.path;
                      var file = File(path);
                      context
                          .read<ProfileEditBloc>()
                          .add(ProfileEditImageUpdated(file));
                    }
                  },
                );
              },
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
            color: AppColors.greenFF01C971,
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
          activeColor: AppColors.greenFF01C971,
          groupValue: value,
          value: gender,
          onChanged: (value) {
            context.read<ProfileEditBloc>().add(
                  ProfileEditGenderChanged(value!),
                );
          },
        ),
      ),
    );
  }
}
