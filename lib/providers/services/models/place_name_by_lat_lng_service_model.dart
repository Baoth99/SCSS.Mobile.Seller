import 'package:seller_app/constants/constants.dart';

class PlaceNameByLatlngServiceModel {
  final String placeId;
  final String name;
  final String address;
  final String district;
  final String city;

  const PlaceNameByLatlngServiceModel({
    this.placeId = Symbols.empty,
    this.name = Symbols.empty,
    this.address = Symbols.empty,
    this.district = Symbols.empty,
    this.city = Symbols.empty,
  });
}
