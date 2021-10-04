import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_function.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message : ${message.messageId}");
  RemoteNotification? notification = message.notification;
  print(notification?.body.toString());
}

Future<void> _firebaseLocalMessagingHandler() async {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // Get icon !
  var intializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/vechaixanh_ic_launcher');
  var initializationSettings =
      InitializationSettings(android: intializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      AndroidNotificationDetails notificationDetails =
          AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
              importance: Importance.max,
              playSound: true,
              priority: Priority.max,
              visibility: NotificationVisibility.public,
              groupKey: channel.groupId);

      NotificationDetails notificationDetailsPlatformSpefics =
          NotificationDetails(android: notificationDetails);

      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          notificationDetailsPlatformSpefics);
    }
  });
}

Future<void> _firebaseOnRefreshToken(
    Future<bool> Function(String) updateFunction) async {
  FirebaseMessaging.instance.onTokenRefresh.listen((deviceID) async {
    if (deviceID.isNotEmpty) {
      var result = await updateFunction(deviceID).catchError((e) {
        print(e);
      });
      print('Onrefreshtoken ${result}');
    }
  }).onError((e) {
    print(e);
  });
}

class FirebaseNotification {
  FirebaseNotification({IdentityServerService? identityServerService}) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late IdentityServerService _identityServerService;

  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseLocalMessagingHandler();

    await _firebaseOnRefreshToken(_identityServerService.updateDeviceId);
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<void> updateToken() async {
    futureAppDuration(getToken().then((deviceID) async {
      if (deviceID != null && deviceID.isNotEmpty) {
        var result = await _identityServerService.updateDeviceId(deviceID);
        print('Update token ${result}');
        if (!result) {
          throw Exception();
        }
      } else {
        throw Exception();
      }
    }).catchError((e) {
      print(e);
    }));
  }
}
