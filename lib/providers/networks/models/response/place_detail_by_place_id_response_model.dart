// To parse this JSON data, do
//
//     final placeDetailByPlaceIdResponseModel = placeDetailByPlaceIdResponseModelFromJson(jsonString);

class PlaceDetailByPlaceIdResponseModel {
  PlaceDetailByPlaceIdResponseModel({
    this.result,
    this.status,
  });

  Result? result;
  String? status;

  factory PlaceDetailByPlaceIdResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PlaceDetailByPlaceIdResponseModel(
        result: Result.fromJson(json["result"]),
        status: json["status"],
      );
}

class Result {
  Result({
    this.placeId,
    this.formattedAddress,
    this.geometry,
    this.name,
  });

  String? placeId;
  String? formattedAddress;
  Geometry? geometry;
  String? name;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        placeId: json["place_id"],
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        name: json["name"],
      );
}

class Geometry {
  Geometry({
    this.location,
  });

  Location? location;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
      );
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );
}
