import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/home_bloc.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/blocs/notification_bloc.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/services/firebase_service.dart';
import 'package:seller_app/ui/layouts/account_layout.dart';
import 'package:seller_app/ui/layouts/activity_layout.dart';
import 'package:seller_app/ui/layouts/home_layout.dart';
import 'package:seller_app/ui/layouts/notification_layout.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/ui/widgets/radiant_gradient_mask.dart';

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

    FirebaseNotification.getNotificationAfterTerminated();

    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   context.read<MainBloc>().add(MainActivityChanged(tabController.index));
    // });
    context.read<MainBloc>().add(MainInitial());

    context.read<HomeBloc>().add(HomeInitial());

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
          FunctionalWidgets.showCustomDialog(context);
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
                    text: 'Th??ng b??o',
                  ),
                  content: const CustomText(
                    text: 'B???n ???? ?????t t???i ??a y??u c???u ???????c cho ph??p',
                  ),
                  actions: [
                    TextButton(
                      child: const CustomText(
                        text: 'Xem c??c y??u c???u ??ang ch???',
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
                        text: '???? hi???u',
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
                selectedItemColor: AppColors.greenFF01C971,
                unselectedFontSize: 23.sp,
                selectedFontSize: 26.sp,
                currentIndex: state.screenIndex,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.home
                            ? Icons.home
                            : Icons.home_outlined,
                      ),
                    ),
                    label: 'Trang ch???',
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, sno) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            RadiantGradientMask(
                              child: Icon(
                                state.screenIndex ==
                                        MainLayoutConstants.notification
                                    ? Icons.notifications
                                    : Icons.notifications_outlined,
                              ),
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
                    label: 'Th??ng b??o',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(null),
                    label: Symbols.empty,
                  ),
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.activity
                            ? Icons.history
                            : Icons.history_outlined,
                      ),
                    ),
                    label: 'Ho???t ?????ng',
                  ),
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.account
                            ? Icons.person
                            : Icons.person_outline,
                      ),
                    ),
                    label: 'T??i kho???n',
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
          backgroundColor: Colors.transparent,
          onPressed: () {
            // Navigator.of(context).pushNamed(Routes.requestStart);
            context.read<MainBloc>().add(MainCheckFullRequest());
          },
          child: Container(
            width: 180.r,
            height: 180.r,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment
                    .bottomRight, // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  AppColors.greenFF61C53D.withOpacity(1),
                  AppColors.greenFF39AC8F.withOpacity(1),
                ], // red to yellow
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
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
