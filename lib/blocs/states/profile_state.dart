part of '../profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.id = Symbols.empty,
    this.name = Symbols.empty,
    this.phone = Symbols.empty,
    this.email,
    this.gender = Gender.male,
    this.address,
    this.birthDate,
    this.image,
    this.totalPoint = 0,
    this.status = FormzStatus.pure,
    ImageProvider<Object>? imageProfile,
  }) {
    this.imageProfile = imageProfile ??
        AssetImage(
          gender == Gender.male
              ? ImagesPaths.maleProfile
              : ImagesPaths.femaleProfile,
        );
  }

  final String id;
  final String name;
  final String phone;
  final String? email;
  final Gender gender;
  final String? address;
  final DateTime? birthDate;
  final String? image;
  final int totalPoint;
  final FormzStatus status;
  late ImageProvider<Object> imageProfile;

  ProfileState copyWith({
    String? name,
    String? phone,
    String? email,
    Gender? gender,
    String? address,
    DateTime? birthDate,
    String? image,
    int? totalPoint,
    FormzStatus? status,
    ImageProvider<Object>? imageProfile,
  }) {
    return ProfileState(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      totalPoint: totalPoint ?? this.totalPoint,
      status: status ?? this.status,
      imageProfile: imageProfile ?? this.imageProfile,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        gender,
        address,
        birthDate,
        image,
        totalPoint,
        status,
        imageProfile,
      ];
}
