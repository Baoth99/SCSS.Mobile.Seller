import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/login_widget.dart';
import 'package:seller_app/utils/env_util.dart';
import '../utils/constants.dart';

class SellerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
          Size(DeviceConstant.logicalWidth, DeviceConstant.logicalHeight),
      builder: () => MaterialApp(
        title: AppConstant.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: AppConstant.primaryColor,
          accentColor: AppConstant.accentColor,
        ),
        home: LoginWidget(),
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
