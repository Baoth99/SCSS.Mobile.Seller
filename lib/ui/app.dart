import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/layouts/login_layout.dart';
import 'package:seller_app/ui/layouts/phone_number_signup_layout.dart';
import '../utils/constants.dart';

class SellerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
          Size(DeviceConstants.logicalWidth, DeviceConstants.logicalHeight),
      builder: () => MaterialApp(
        title: AppConstants.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: AppConstants.primaryColor,
          accentColor: AppConstants.accentColor,
        ),
        initialRoute: Routes.initial,
        routes: {
          Routes.login: (context) => const LoginLayout(),
          Routes.signupAddingPhoneNumber: (context) =>
              const PhoneNumberSignupLayout(),
        },
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
