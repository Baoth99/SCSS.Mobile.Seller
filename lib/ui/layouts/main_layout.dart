import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/account_layout.dart';
import 'package:seller_app/ui/layouts/activity_layout.dart';
import 'package:seller_app/ui/layouts/home_layout.dart';
import 'package:seller_app/ui/layouts/notification_layout.dart';
import 'package:seller_app/utils/common_utils.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPreferenceUtils.getString(APIKeyConstants.accessToken)
        .then((value) => print(value));
    SharedPreferenceUtils.getString(APIKeyConstants.refreshToken)
        .then((value) => print(value));
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc()..add(MainInitial()),
      child: Scaffold(
        extendBody: true,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.greenFF61C53D,
          onPressed: () => Navigator.of(context).pushNamed(Routes.bookingStart),
          child: const Icon(Icons.add),
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
    );
  }
}
