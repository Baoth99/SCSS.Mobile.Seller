import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/account_layout.dart';
import 'package:seller_app/ui/layouts/activity_layout.dart';
import 'package:seller_app/ui/layouts/home_layout.dart';
import 'package:seller_app/ui/layouts/notification_layout.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MainBloc>(context)
        ..add(
          MainInitial(),
        ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state.statusCreateRequest.isSubmissionInProgress) {
            showDialog(
              context: context,
              builder: (context) => const CustomProgressIndicatorDialog(),
            );
          }
          if (state.statusCreateRequest.isSubmissionSuccess) {
            Navigator.popUntil(
              context,
              ModalRoute.withName(Routes.main),
            );
            var isFull = state.isRequestFull;
            if (isFull != null) {
              if (isFull) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const CustomText(
                      text: 'Thông báo',
                    ),
                    content: const CustomText(
                      text: 'Bạn đã đặt tối đa yêu cầu được cho phép',
                    ),
                    actions: [
                      TextButton(
                        child: const CustomText(
                          text: 'Xem các yêu cầu đang chờ',
                        ),
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(Routes.main),
                          );
                          context.read<MainBloc>().add(
                                const MainBarItemTapped(
                                    MainLayoutConstants.activity),
                              );
                        },
                      ),
                      TextButton(
                        child: const CustomText(
                          text: 'Đã hiểu',
                        ),
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(Routes.main),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pushNamed(context, Routes.requestStart);
              }
            }
          }
        },
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.greenFF61C53D,
                  unselectedFontSize: 23.sp,
                  selectedFontSize: 26.sp,
                  currentIndex: state.screenIndex,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_outlined),
                      label: 'Thông báo',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(null),
                      label: Symbols.empty,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_outlined),
                      label: 'Hoạt động',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Tài khoản',
                    ),
                  ],
                  onTap: (value) {
                    if (MainLayoutConstants.mainTabs.contains(value)) {
                      context.read<MainBloc>().add(MainBarItemTapped(value));
                    }
                  },
                );
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(Routes.requestStart);
              context.read<MainBloc>().add(MainCheckFullRequest());
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              int index = state.screenIndex;
              switch (index) {
                case MainLayoutConstants.home:
                  return const HomeLayout();
                case MainLayoutConstants.notification:
                  return const NotificationLayout();
                case MainLayoutConstants.activity:
                  return const ActivityLayout();
                case MainLayoutConstants.account:
                  return const AccountLayout();
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
