import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/blocs/notification_bloc.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/blocs/request_bloc.dart';
import 'package:seller_app/blocs/request_time_bloc.dart';
import 'package:seller_app/ui/layouts/forget_password_otp_layout.dart';
import 'package:seller_app/ui/layouts/forget_password_phone_number_layout.dart';
import 'package:seller_app/ui/layouts/request_detail_layout.dart';
import 'package:seller_app/ui/layouts/main_layout.dart';
import 'layouts/layouts.dart';
import '../constants/constants.dart';

class SellerApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          DeviceConstants.logicalWidth, DeviceConstants.logicalHeight),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RequestBloc(),
          ),
          BlocProvider(
            create: (context) => RequestTimeBloc(),
          ),
          BlocProvider(
            create: (context) => MainBloc(),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: AppConstants.appTitle,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale(Symbols.vietnamLanguageCode),
          ],
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: AppConstants.primaryColor,
            accentColor: AppConstants.accentColor,
          ),
          initialRoute: Routes.initial,
          routes: {
            //login
            Routes.login: (_) => const LoginLayout(),

            //main
            Routes.main: (_) => const MainLayout(),

            //signup
            Routes.signupPhoneNumber: (_) => const SignupPhoneNumberLayout(),
            Routes.signupOTP: (_) => const SignupOTPLayout(),
            Routes.signupInformation: (_) => const SignupInformationLayout(),

            //Request
            Routes.requestStart: (_) => const RequestStartLayout(),
            Routes.requestLocationPicker: (_) =>
                const RequestLocationPickerLayout(),
            Routes.requestMapPicker: (_) => const RequestMapPickerLayout(),
            Routes.requestBulky: (_) => const RequestBulkyLayout(),

            //Request Detail
            Routes.requestDetail: (_) => const RequestDetailLayout(),

            //profile
            Routes.profileEdit: (_) => const ProfileEditLayout(),
            Routes.profilePasswordEdit: (_) =>
                const ProfilePasswordEditLayout(),
            Routes.forgetPasswordPhoneNumber: (_) =>
                const ForgetPasswordPhoneNumberLayout(),
            Routes.forgetPasswordOTP: (_) => const ForgetPasswordOTPLayout(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               EnvBaseAppSettingValue.baseApiUrl,
//             ),
//             Text(
//               EnvID4AppSettingValue.apiUrl,
//             ),
//             Text(
//               EnvID4AppSettingValue.clientId,
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
