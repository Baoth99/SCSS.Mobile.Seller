import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/account_layout.dart';
import 'package:seller_app/ui/layouts/activity_layout.dart';
import 'package:seller_app/ui/layouts/home_layout.dart';
import 'package:seller_app/ui/layouts/notification_layout.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc()..add(MainInitial()),
      child: Scaffold(
        bottomNavigationBar: Stack(
          alignment: const FractionalOffset(.5, 1.0),
          clipBehavior: Clip.none,
          children: [
            BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return BottomNavigationBar(
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
                      icon: Icon(Icons.history_outlined),
                      label: 'Hoạt động',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Tài khoản',
                    ),
                  ],
                  onTap: (value) =>
                      context.read<MainBloc>().add(MainBarItemTapped(value)),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 130.h),
              child: FloatingActionButton(
                backgroundColor: AppColors.greenFF61C53D,
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.bookingStart),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            int index = state.screenIndex;
            switch (index) {
              case 0:
                return const HomeLayout();
              case 1:
                return const NotificationLayout();
              case 2:
                return const ActivityLayout();
              case 3:
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
