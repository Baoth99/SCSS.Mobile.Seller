import 'package:get_it/get_it.dart';
import 'package:seller_app/providers/networks/activity_network.dart';
import 'package:seller_app/providers/networks/collecting_request_network.dart';
import 'package:seller_app/providers/networks/goong_map_network.dart';
import 'package:seller_app/providers/networks/identity_server_network.dart';
import 'package:seller_app/providers/services/activity_service.dart';
import 'package:seller_app/providers/services/collecting_request_service.dart';
import 'package:seller_app/providers/services/firebase_service.dart';
import 'package:seller_app/providers/services/goong_map_service.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';

final getIt = GetIt.instance;
Future<void> configureDependencies() async {
  // Network
  getIt.registerLazySingleton<GoongMapNetwork>(
    () => GoongMapNetworkImpl(),
  );
  getIt.registerLazySingleton<IdentityServerNetwork>(
    () => IdentityServerNetworkImpl(),
  );
  getIt.registerLazySingleton<CollectingRequestNetwork>(
    () => CollectingRequestNetworkImpl(),
  );
  getIt.registerLazySingleton<ActivityNetwork>(
    () => ActivityNetworkImpl(),
  );

  // Service
  getIt.registerLazySingleton<GoongMapService>(
    () => GoongMapServiceImpl(),
  );
  getIt.registerLazySingleton<IdentityServerService>(
    () => IdentityServerServiceImpl(),
  );
  getIt.registerLazySingleton<CollectingRequestService>(
    () => CollectingRequestServiceImpl(),
  );
  getIt.registerLazySingleton<ActivityService>(
    () => ActivityServiceImpl(),
  );

  //firebase
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
}
