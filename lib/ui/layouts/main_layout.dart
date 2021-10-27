import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/blocs/notification_bloc.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/account_layout.dart';
import 'package:seller_app/ui/layouts/activity_layout.dart';
import 'package:seller_app/ui/layouts/home_layout.dart';
import 'package:seller_app/ui/layouts/notification_layout.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   context.read<MainBloc>().add(MainActivityChanged(tabController.index));
    // });
    context.read<MainBloc>().add(MainInitial());

    // Get number of  unread notifcation count
    context.read<NotificationBloc>().add(NotificationUncountGet());

    //profile
    context.read<ProfileBloc>().add(ProfileClear());
    context.read<ProfileBloc>().add(ProfileInitial());
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
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
                        if (state.screenIndex != MainLayoutConstants.activity) {
                          context.read<MainBloc>().add(
                                const MainBarItemTapped(
                                    MainLayoutConstants.activity),
                              );
                        }
                        tabController.animateTo(0);
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
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      state.screenIndex == MainLayoutConstants.home
                          ? Icons.home
                          : Icons.home_outlined,
                    ),
                    label: 'Trang chủ',
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, sno) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              state.screenIndex ==
                                      MainLayoutConstants.notification
                                  ? Icons.notifications
                                  : Icons.notifications_outlined,
                            ),
                            sno.unreadCount > 0
                                ? Positioned(
                                    // draw a red marble
                                    top: -25.0.h,
                                    right: -20.0.w,
                                    child: Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          color: Colors.white,
                                          text: sno.unreadCount <= 99
                                              ? '${sno.unreadCount}'
                                              : '99+',
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        );
                      },
                    ),
                    label: 'Thông báo',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(null),
                    label: Symbols.empty,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      state.screenIndex == MainLayoutConstants.activity
                          ? Icons.history
                          : Icons.history_outlined,
                    ),
                    label: 'Hoạt động',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      state.screenIndex == MainLayoutConstants.account
                          ? Icons.person
                          : Icons.person_outline,
                    ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                return HomeLayout(
                  tabController: tabController,
                );
              case MainLayoutConstants.notification:
                return const NotificationLayout();
              case MainLayoutConstants.activity:
                return ActivityLayout(
                  controller: tabController,
                );
              case MainLayoutConstants.account:
                return const AccountLayout();
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
