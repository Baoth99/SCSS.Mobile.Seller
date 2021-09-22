import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/configs/mapper_config.dart';
import 'package:seller_app/providers/services/firebase_service.dart';
import 'package:seller_app/ui/app.dart';
import 'package:seller_app/utils/env_util.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.production);
  configureDependencies();
  configureMappers();
  final firebase = getIt.get<FirebaseNotification>();
  await firebase.initialize();
  print(await firebase.getToken());
  runApp(SellerApp());
}
