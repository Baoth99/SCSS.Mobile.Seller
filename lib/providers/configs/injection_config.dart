import 'package:get_it/get_it.dart';
import 'package:seller_app/providers/services/firebase_service.dart';

final getIt = GetIt.instance;
void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
}
