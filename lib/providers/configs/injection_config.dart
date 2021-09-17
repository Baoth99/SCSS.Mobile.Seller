import 'package:get_it/get_it.dart';
import 'package:seller_app/providers/networks/goong_map_network.dart';
import 'package:seller_app/providers/services/firebase_service.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';

final getIt = GetIt.instance;
void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());

  // Network
  getIt.registerLazySingleton<GoongMapNetwork>(() => GoongMapNetwork());

  // Service
  getIt.registerLazySingleton<GoongMapService>(() => GoongMapService());
}
