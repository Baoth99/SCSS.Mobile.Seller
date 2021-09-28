import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/common_scaffold_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonScaffoldTitle('Thông báo'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const CommonMarginContainer(
        child: NotificationBody(),
      ),
    );
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => NotificationElement(
            true,
            'Đơn hàng đã hoàn tất',
            'Đơn hàng tại BachHoaXanh Levanviet đã hoàn tất. Cảm ơn bạn đã chọn Cheapee cho hôm nay !',
            '10 phút trước'),
        separatorBuilder: (context, index) => _divider(),
        itemCount: 11);
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Divider(
        thickness: 6.h,
      ),
    );
  }
}

class NotificationElement extends StatelessWidget {
  const NotificationElement(
    this.isRead,
    this.title,
    this.content,
    this.time, {
    Key? key,
  }) : super(key: key);

  final bool isRead;
  final String title;
  final String content;
  final String time;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Icon(
            isRead ? Icons.drafts_outlined : Icons.markunread_mailbox_outlined,
          ),
          Container(
            child: const VerticalDivider(color: Colors.black, width: 20),
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 45.sp,
                  color: isRead ? AppColors.greenFF61C53D : AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  child: CustomText(
                    text: content,
                    color: Colors.grey[700],
                  ),
                ),
                CustomText(
                  text: time,
                  fontSize: 34.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
