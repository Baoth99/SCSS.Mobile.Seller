// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:seller_app/providers/models/request/reverse_geocoding_request_model.dart';
// import 'package:seller_app/providers/models/response/reverse_geocoding_response_model.dart';
// import 'package:seller_app/providers/networks/goong_map_network.dart';
// import 'package:seller_app/utils/env_util.dart';
// import 'package:test/test.dart';

// void main() {
//   test(
//     'Test ',
//     () async {
//       await dotenv.load(fileName: EnvAppSetting.testing);
//       var requestModel = const ReverseGeocodingRequestModel(
//           latitude: 10.7209121, longitude: 0);

//       var goongMapNetwork = GoongMapNetwork();

//       var expectResponseModel = ReverseGeocodingResponseModel(
//         results: [],
//         status: 'BAD_REQUEST',
//       );

//       var actualResponseModel =
//           goongMapNetwork.getReverseGeocoding(requestModel);

//       expect(await actualResponseModel, expectResponseModel);
//     },
//   );
// }
