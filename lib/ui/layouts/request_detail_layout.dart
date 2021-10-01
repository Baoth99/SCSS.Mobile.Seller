import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RequestDetailArguments {
  final String requestId;
  const RequestDetailArguments({
    required this.requestId,
  });
}

class RequestDetailLayout extends StatelessWidget {
  const RequestDetailLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailArguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        title: CustomText(
          text: 'Chi tiết yêu cầu',
          color: AppColors.white,
          fontSize: 43.sp,
        ),
        color: AppColors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const RequestDetailHeader(),
          const RequestDetailDivider(),
          const RequestDetailRating(),
          const RequestDetailDivider(),
          const RequestDetailCollectorInfo(),
          const RequestDetailDivider(),
          const RequestDetailBody(),
          const RequestDetailDivider(),
          const RequestDetailBill(),
          const RequestDetailDivider(),
          const RequestDetailTime(),
          _getCancelButton(context),
        ],
      ),
    );
  }

  Widget _getCancelButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 40.h,
        top: 40.h,
      ),
      child: CommonMarginContainer(
        child: ElevatedButton(
          onPressed: _cancelPressed(context),
          style: ElevatedButton.styleFrom(
            primary: AppColors.orangeFFF5670A,
            minimumSize: Size(
              double.infinity,
              WidgetConstants.buttonCommonHeight.h,
            ),
          ),
          child: CustomText(
            text: 'Hủy đơn hẹn',
            fontSize: WidgetConstants.buttonCommonFrontSize.sp,
            fontWeight: WidgetConstants.buttonCommonFrontWeight,
          ),
        ),
      ),
    );
  }

  void Function() _cancelPressed(BuildContext context) {
    return () {
      FunctionalWidgets.showCustomModalBottomSheet(
        context: context,
        child: _getCancelWidget(context),
        title: 'Hủy Đơn Hẹn',
        routeClosed: Routes.requestDetail,
      );
    };
  }

  Widget _getCancelWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScaffoldMargin.w,
            vertical: 20.h,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
          color: Colors.orange[900]!.withOpacity(0.2),
          child: Row(
            children: [
              const Icon(
                Icons.error,
                color: AppColors.orangeFFF5670A,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 40.w,
                  ),
                  child: CustomText(
                    text:
                        'Vui lòng điền lí do hủy đơn hẹn. Lưu ý: thao tác này sẽ không thể hoàn tác',
                    color: AppColors.orangeFFF5670A,
                    fontSize: 40.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        const CommonMarginContainer(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Lý do hủy',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ),
        CommonMarginContainer(
          child: ElevatedButton(
            onPressed: () {},
            child: CustomText(
              text: 'Đồng ý',
              fontSize: WidgetConstants.buttonCommonFrontSize.sp,
              fontWeight: WidgetConstants.buttonCommonFrontWeight,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                WidgetConstants.buttonCommonHeight.h,
              ),
              primary: AppColors.greenFF61C53D,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestDetailTime extends StatelessWidget {
  const RequestDetailTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        children: [
          _getDataRow('Thời gian đặt', '08-08-2021 00:23'),
          _getDataRow('Thời gian được xác nhận', '10-08-2021 08:23'),
          _getDataRow('Thời gian thu gom', '01-10-2021 07:23'),
        ],
      ),
    );
  }

  Widget _getDataRow(String key, String value) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 9.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: _getCustomText(key),
          ),
          _getCustomText(value),
        ],
      ),
    );
  }

  Widget _getCustomText(String text) {
    return CustomText(
      text: text,
      fontSize: 38.sp,
      color: Colors.grey[700],
    );
  }
}

class RequestDetailRating extends StatelessWidget {
  const RequestDetailRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        children: [
          _getText('Bạn thấy dịch vụ như thế nào?'),
          _getText('(1 là thất vọng, 5 là tuyệt vời)'),
          _getStarRaing(
            onRatingUpdate: (rating) {
              FunctionalWidgets.showCustomModalBottomSheet(
                context: context,
                child: _getFeedback(
                  context,
                  'https://znews-photo.zadn.vn/w660/Uploaded/ngogtn/2021_04_25/avatar_movie_Cropped.jpg',
                  'Phạm Trung Hiếu',
                  '0979637678',
                  rating,
                ),
                routeClosed: Routes.requestDetail,
                title: 'Đánh giá dịch vụ',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getFeedback(
    BuildContext context,
    String image,
    String name,
    String phone,
    double initialStar,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Divider(
            thickness: 50.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
        ),
        CommonMarginContainer(
          child: IntrinsicHeight(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 80.0.r,
                  backgroundImage: NetworkImage(image),
                  backgroundColor: Colors.transparent,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 50.w,
                  ),
                  child: CustomText(
                    text: name,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Divider(
            thickness: 5.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 20.h,
          ),
        ),
        _getStarRaing(
          onRatingUpdate: (value) {},
          intialRating: initialStar,
        ),
        Container(
          child: CustomText(
            text: 'Cảm ơn bạn đã đánh giá!',
            fontSize: 50.sp,
          ),
          margin: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
        ),
        const CommonMarginContainer(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Hãy chia sẻ trải nghiệm của bạn nhé',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greenFF61C53D),
              ),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ),
        CommonMarginContainer(
          child: ElevatedButton(
            onPressed: () {},
            child: CustomText(
              text: 'Gửi đánh giá',
              fontSize: WidgetConstants.buttonCommonFrontSize.sp,
              fontWeight: WidgetConstants.buttonCommonFrontWeight,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                WidgetConstants.buttonCommonHeight.h,
              ),
              primary: AppColors.greenFF61C53D,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getStarRaing({
    bool ignoreGestures = false,
    double intialRating = 0,
    required void Function(double) onRatingUpdate,
  }) {
    return RatingBar.builder(
      initialRating: intialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      ignoreGestures: ignoreGestures,
      onRatingUpdate: onRatingUpdate,
    );
  }

  Widget _getText(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 40.sp,
    );
  }
}

class RequestDetailBill extends StatelessWidget {
  const RequestDetailBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestDetailElementPattern(
            icon: Icons.receipt_outlined,
            title: 'Thông tin đơn hàng',
            child: _bodyBill(),
            contentLeftMargin: 0.w,
          )
        ],
      ),
    );
  }

  Widget _bodyBill() {
    return Column(
      children: [
        _getItems(),
        _getDivider(),
        _getSubInfo(),
        _getDivider(),
        Row(
          children: [
            Expanded(
              child: _getFinalText('Tổng cộng'),
            ),
            _getFinalText('185.000 ₫')
          ],
        )
      ],
    );
  }

  Widget _getFinalText(String text) {
    return CustomText(
      text: text,
      fontSize: 48.sp,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _getItems() {
    return Column(
      children: [
        _getItem(
          'Nhựa thau',
          '10 kg',
          '100.000 ₫',
        ),
        _getItem(
          'Nhựa thau',
          '-',
          '100.000 ₫',
        ),
      ],
    );
  }

  Widget _getItem(String name, String quantity, String price) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 50.w,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getItemText(name),
          _getItemText(quantity),
          _getItemText(price),
        ],
      ),
    );
  }

  _getItemText(String text) {
    return CustomText(
      text: text,
      fontSize: 40.sp,
      color: Colors.grey[800],
    );
  }

  _getDivider() {
    return Divider(
      thickness: 2.5.h,
    );
  }

  Widget _getSubInfo() {
    return Column(
      children: [
        _getSubInfoItem(
          'Tạm tính',
          '200.000 ₫',
        ),
        _getSubInfoItem(
          'Phí dịch vụ',
          '-15.000 ₫',
        ),
        _getSubInfoItem(
          'Điểm thưởng',
          '20 điểm',
        ),
      ],
    );
  }

  Widget _getSubInfoItem(String name, String value) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: _getSubInfoItemText(name),
          ),
          _getSubInfoItemText(value),
        ],
      ),
    );
  }

  Widget _getSubInfoItemText(String text) {
    return CustomText(
      text: text,
      color: Colors.grey[600],
    );
  }
}

class RequestDetailCollectorInfo extends StatelessWidget {
  const RequestDetailCollectorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: IntrinsicHeight(
        child: Row(
          children: [
            CircleAvatar(
              radius: 110.0.r,
              backgroundImage: NetworkImage(
                  'https://znews-photo.zadn.vn/w660/Uploaded/ngogtn/2021_04_25/avatar_movie_Cropped.jpg'),
              backgroundColor: Colors.transparent,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 50.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _getLineInfo(Icons.person_outline, 'Trần Đức Tiến'),
                  _getLineInfo(Icons.phone_outlined, '09767234215'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLineInfo(IconData icon, String data) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.greenFF61C53D,
        ),
        Container(
          margin: EdgeInsets.only(
            left: 30.w,
          ),
          child: CustomText(
            text: data,
            fontSize: 45.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class RequestDetailBody extends StatelessWidget {
  const RequestDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Thông tin đặt hẹn',
            fontSize: 40.sp,
            fontWeight: FontWeight.w500,
          ),
          Container(
            child: Column(
              children: [
                RequestDetailElementPattern(
                  icon: Icons.place,
                  title: 'Địa chỉ thu gom',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        fontSize: 47.sp,
                        text: 'Khu dân cư 6B Kiên Cường',
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 12.h,
                        ),
                        child: CustomText(
                          text:
                              'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
                          fontSize: 39.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                RequestDetailElementPattern(
                  icon: AppIcons.event,
                  title: 'Thời gian hẹn thu gom',
                  child: CustomText(
                    text: 'Th 3, 24 thg 8, 09:45 - 10:00',
                    fontSize: 47.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RequestDetailElementPattern(
                  icon: Icons.kitchen,
                  title: 'Có đồ cồng kềnh',
                  child: CustomText(
                    text: 'Có',
                    fontSize: 47.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RequestDetailElementPattern(
                  icon: Icons.image_outlined,
                  title: 'Ảnh ve chai',
                  child: _image(context),
                ),
                RequestDetailElementPattern(
                  icon: Icons.notes,
                  title: 'Ghi chú',
                  child: CustomText(
                    text:
                        'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọi tôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
                    fontSize: 40.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 40.h,
        ),
        constraints: BoxConstraints(maxHeight: 600.h, minHeight: 400.h),
        child: ''.isEmpty
            ? Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0.r),
                    child: Image.network(
                        'https://i.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U'),
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
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => const ExistedPhotoDialog(),
                          // );
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
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const PhotoDialog(),
                    // );
                  },
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    size: 80.0.r,
                    color: AppColors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RequestDetailElementPattern extends StatelessWidget {
  RequestDetailElementPattern({
    Key? key,
    required this.icon,
    required this.title,
    required this.child,
    double? contentLeftMargin,
  }) : super(key: key) {
    this.contentLeftMargin = contentLeftMargin ?? 80.w;
  }

  final IconData icon;
  final String title;
  final Widget child;
  late double contentLeftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.greenFF61C53D,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 36.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              left: contentLeftMargin,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class RequestDetailHeader extends StatelessWidget {
  const RequestDetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200.h,
        ),
        child: Column(
          children: <Widget>[
            _requestId(context),
            _getStepper(context),
          ],
        ),
      ),
    );
  }

  Widget _requestId(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.description_outlined,
          color: AppColors.greenFF61C53D,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: const CustomText(
              text: 'Mã Đơn Hẹn: GK-12-5597360',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            FunctionalWidgets.showCustomModalBottomSheet<String>(
              context: context,
              child: _getQrCode(),
              routeClosed: Routes.requestDetail,
            );
          },
          icon: Icon(
            Icons.qr_code_2_outlined,
            size: 80.sp,
          ),
        ),
      ],
    );
  }

  Widget _getQrCode() {
    return Container(
      margin: EdgeInsets.only(
        top: 400.h,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Đơn hẹn\nGK-12-5597360',
              textAlign: TextAlign.center,
              fontSize: 50.sp,
              fontWeight: FontWeight.w500,
            ),
            QrImage(
              data:
                  "12321312321312312321321321324523434rdfgfhfgnfghgrfthfdghdfgfdgdfgdfgfdgdrfgdfgdfgdfgdfgfdgfdg",
              version: QrVersions.auto,
              size: 600.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStepper(BuildContext context) {
    return Container(
      height: 220.h,
      child: Theme(
        data: Theme.of(context).copyWith(
          shadowColor: Colors.transparent,
        ),
        child: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (context, {onStepCancel, onStepContinue}) {
            return Row(
              children: <Widget>[
                Container(
                  child: null,
                ),
                Container(
                  child: null,
                ),
                Container(
                  child: null,
                ),
              ], // <Widget>[]
            );
          },
          currentStep: 0,
          steps: <Step>[
            Step(
              state: StepState.complete,
              isActive: true,
              title: CustomText(
                text: 'Đặt hẹn',
                fontSize: 28.sp,
              ),
              content: Container(),
            ),
            Step(
              state: StepState.complete,
              title: CustomText(
                text: 'Đã nhận',
                fontSize: 28.sp,
              ),
              content: Container(),
            ),
            Step(
              state: StepState.complete,
              title: CustomText(
                text: 'Hoàn thành',
                fontSize: 28.sp,
              ),
              content: Container(),
            )
          ],
        ),
      ),
    );
  }
}

class RequestDetailDivider extends StatelessWidget {
  const RequestDetailDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 4.h,
      height: 100.h,
    );
  }
}
