part of '../profile_edit_bloc.dart';

class ProfileEditState extends Equatable {
  ProfileEditState({
    this.imageFile,
    this.imagePath,
    this.name = const Name.pure(),
    this.phoneNumber = Symbols.empty,
    this.address = const Address.pure(),
    this.email = const Email.pure(),
    this.gender = Gender.male,
    this.birthDate = const Birthdate.pure(),
    this.status = FormzStatus.pure,
    this.cname,
    this.caddress,
    this.cemail,
    this.cgender,
    this.cbirthDate,
  });

  File? imageFile;
  String? imagePath;
  Name name;
  String phoneNumber;
  Address address;
  Email email;
  Gender gender;
  Birthdate birthDate;
  FormzStatus status;

  String? cname;
  String? caddress;
  String? cemail;
  Gender? cgender;
  DateTime? cbirthDate;

  ProfileEditState copyWith({
    File? imageFile,
    String? imagePath,
    Name? name,
    String? phoneNumber,
    Address? address,
    Email? email,
    Gender? gender,
    Birthdate? birthDate,
    FormzStatus? status,
    String? cname,
    String? caddress,
    String? cemail,
    Gender? cgender,
    DateTime? cbirthDate,
  }) {
    return ProfileEditState(
      imageFile: imageFile ?? this.imageFile,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      status: status ?? this.status,
      cname: cname ?? this.cname,
      caddress: caddress ?? this.caddress,
      cemail: cemail ?? this.cemail,
      cgender: cgender ?? this.cgender,
      cbirthDate: cbirthDate ?? this.cbirthDate,
    );
  }

  @override
  List<Object?> get props => [
        imageFile,
        imagePath,
        name,
        phoneNumber,
        address,
        email,
        gender,
        birthDate,
        status,
        cname,
        caddress,
        cemail,
        cgender,
        cbirthDate,
      ];
}
