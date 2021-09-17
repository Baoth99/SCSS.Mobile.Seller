import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/ui/widgets/map_widget.dart';

class BookingStartLayout extends StatelessWidget {
  const BookingStartLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        elevation: 0,
        color: AppColors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScaffoldMargin.w,
        ),
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _Title(),
        Expanded(
          child: ListView(
            children: [
              const _Form(),
            ],
          ),
        ),
      ],
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
        GestureDetector(
          onTap: _onPlaceInputTapped(context),
          child: _InputContainer(
            child: CustomText(
              text: BookingStartLayoutConstants.placeHintText,
              color: AppColors.greyFF9098B1,
              fontSize: BookingStartLayoutConstants.inputFontSize.sp,
            ),
            iconData: AppIcons.place,
          ),
        ),
        _InputContainer(
          child: CustomText(
            text: BookingStartLayoutConstants.timeHintText,
            color: AppColors.greyFF9098B1,
            fontSize: BookingStartLayoutConstants.inputFontSize.sp,
          ),
          iconData: AppIcons.event,
        ),
        const _InputContainer(
          child: _NoteField(),
          iconData: AppIcons.feedOutlined,
        ),
        const _SubbmittedButton(),
      ],
    );
  }

  Function()? _onPlaceInputTapped(BuildContext context) {
    return () {
      Navigator.pushNamed(context, Routes.bookingLocationPicker);
    };
  }
}

class _SubbmittedButton extends StatelessWidget {
  const _SubbmittedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: WidgetConstants.buttonCommonFrontSize.sp,
          fontWeight: WidgetConstants.buttonCommonFrontWeight,
        ),
        primary: AppColors.greenFF61C53D,
        minimumSize: Size(
          double.infinity,
          WidgetConstants.buttonCommonHeight.h,
        ),
      ),
      child: const CustomText(
        text: BookingStartLayoutConstants.firstButtonTitle,
      ),
    );
  }
}

// class _TitleInput extends StatelessWidget {
//   const _TitleInput({
//     Key? key,
//     required this.child,
//     required this.iconData,
//   }) : super(key: key);

//   final Widget child;
//   final IconData iconData;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           margin: EdgeInsets.only(
//             right: 30.w,
//           ),
//           child: Icon(
//             iconData,
//             color: AppColors.greenFF61C53D,
//           ),
//         ),
//         Expanded(
//           child: child,
//         ),
//       ],
//     );
//   }
// }

class _InputContainer extends StatelessWidget {
  const _InputContainer({
    Key? key,
    required this.child,
    required this.iconData,
  }) : super(key: key);
  final Widget child;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15.sp,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 30.0.h,
        horizontal: 30.0.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: <BoxShadow>[
          const BoxShadow(
            color: AppColors.greyFF9098B1,
            offset: Offset(2.5, 5),
            blurRadius: 3,
            spreadRadius: -5.5,
          ),
        ],
        border: Border.all(
          color: AppColors.greyFF9098B1,
        ),
        borderRadius: BorderRadius.circular(
          15.0.r,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 30.w,
            ),
            child: Icon(
              iconData,
              color: AppColors.greenFF61C53D,
              size: 55.sp,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      maxLength: 200,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: AppColors.greyFF9098B1,
        ),
        isDense: true,
        contentPadding: EdgeInsets.all(0),
        border: InputBorder.none,
        hintText: BookingStartLayoutConstants.noteHintText,
      ),
      textInputAction: TextInputAction.done,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 40.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomText(
            text: BookingStartLayoutConstants.title,
            fontSize: 65.sp,
            fontWeight: FontWeight.w500,
          ),
          const CustomText(
            text: BookingStartLayoutConstants.subTitle,
          ),
        ],
      ),
    );
  }
}
