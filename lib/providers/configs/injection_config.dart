import 'package:get_it/get_it.dart';
import 'package:seller_app/providers/networks/goong_map_network.dart';
import 'package:seller_app/providers/networks/identity_server_network.dart';
import 'package:seller_app/providers/services/firebase_service.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';

final getIt = GetIt.instance;
void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());

  // Network
  getIt.registerLazySingleton<GoongMapNetwork>(
    () => GoongMapNetworkImpl(),
  );
  getIt.registerLazySingleton<IdentityServerNetwork>(
    () => IdentityServerNetworkImpl(),
  );

  // Service
  getIt.registerLazySingleton<GoongMapService>(
    () => GoongMapServiceImpl(),
  );
  getIt.registerLazySingleton<IdentityServerService>(
    () => IdentityServerServiceImpl(),
  );
}
