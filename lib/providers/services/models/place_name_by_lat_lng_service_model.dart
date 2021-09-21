import 'package:seller_app/constants/constants.dart';

class PlaceNameByLatlngServiceModel {
  final String name;
  final String address;
  const PlaceNameByLatlngServiceModel({
    this.name = Symbols.empty,
    this.address = Symbols.empty,
  });
}
