import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/booking_bloc.dart';
import 'package:seller_app/blocs/models/yes_no_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/ui/widgets/sumitted_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/ui/widgets/view_image_layour.dart';

class BookingBulkyLayout extends StatelessWidget {
  const BookingBulkyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          const BookingBulkyLayoutBody(),
        ],
      ),
    );
  }
}

class BookingBulkyLayoutBody extends StatelessWidget {
  const BookingBulkyLayoutBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const BookingBulkyLayoutBulkyInput(),
        const CommonMarginContainer(
          child: BookingBulkyLayoutImageInput(),
        ),
        CommonMarginContainer(
          child: SubmittedButton(title: 'Xác nhận', onPressed: _onPressed),
        ),
      ],
    );
  }

  void Function() _onPressed(BuildContext context) {
    return () {};
  }
}

class BookingBulkyLayoutBulkyInput extends StatelessWidget {
  const BookingBulkyLayoutBulkyInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CommonMarginContainer(
          child: CustomText(
            text: BookingBulkyLayoutConstants.title,
            fontSize: 45.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 30.h,
          ),
          child: CommonMarginContainer(
            child: CustomText(
              text: BookingBulkyLayoutConstants.exampleText,
              fontSize: 38.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                RadioButtonInput(
                  groupValue: state.bulky,
                  value: YesNo.no,
                  text: 'Không',
                ),
                RadioButtonInput(
                  groupValue: state.bulky,
                  value: YesNo.yes,
                  text: 'Có',
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

class BookingBulkyLayoutImageInput extends StatelessWidget {
  const BookingBulkyLayoutImageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: BookingBulkyLayoutConstants.imageTitle,
          fontSize: 45.sp,
          fontWeight: FontWeight.w500,
        ),
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 40.h,
            ),
            constraints: BoxConstraints(maxHeight: 600.h, minHeight: 400.h),
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) => state.imagePath.isNotEmpty
                  ? Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0.r),
                          child: Image.file(File(state.imagePath)),
                        ),
                        Positioned.fill(
                          child: Container(
                            height: double.minPositive,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0.r),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.add_a_photo_outlined),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const ExistedPhotoDialog(),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 100.0.r,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PhotoDialog(),
                          );
                        },
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          size: 80.0.r,
                          color: AppColors.white,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class RadioButtonInput extends StatelessWidget {
  const RadioButtonInput({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.text,
  }) : super(key: key);
  final YesNo groupValue;
  final YesNo value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BookingBloc>().add(BookingBulkyChosen(value));
      },
      child: Container(
        color: groupValue == value ? Colors.green[50] : null,
        child: ListTile(
          leading: Radio<YesNo>(
            activeColor: AppColors.greenFF61C53D,
            groupValue: groupValue,
            value: value,
            onChanged: (value) {},
          ),
          title: CustomText(
            text: text,
            fontSize: 45.sp,
          ),
        ),
      ),
    );
  }
}

class ExistedPhotoDialog extends StatelessWidget {
  const ExistedPhotoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const CustomText(text: 'Thay đổi ảnh'),
      children: [
        BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        ViewImageLayout(state.imagePath),
                  ),
                );
              },
              child: ListTile(
                title: CustomText(
                  text: 'Xem ảnh',
                  fontSize: 50.sp,
                ),
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            context.read<BookingBloc>().add(BookingImageDeleted());
            Navigator.popUntil(
                context, ModalRoute.withName(Routes.bookingBulky));
          },
          child: ListTile(
            title: CustomText(
              text: 'Xóa ảnh',
              fontSize: 50.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoDialog extends StatelessWidget {
  const PhotoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const CustomText(text: 'Thêm tấm ảnh'),
      children: [
        TextButton(
          onPressed: () async {
            final ImagePicker _picker = ImagePicker();
            final XFile? photo =
                await _picker.pickImage(source: ImageSource.camera);
            _addImage(context, photo);
          },
          child: ListTile(
            title: CustomText(
              text: 'Chụp ảnh',
              fontSize: 50.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final ImagePicker _picker = ImagePicker();
            final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
            _addImage(context, image);
          },
          child: ListTile(
            title: CustomText(
              text: 'Chọn ảnh',
              fontSize: 50.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _addImage(BuildContext context, XFile? photo) {
    if (photo != null && photo.path.isNotEmpty) {
      context.read<BookingBloc>().add(
            BookingImageAdded(photo.path),
          );
    }
    Navigator.popUntil(context, ModalRoute.withName(Routes.bookingBulky));
  }
}