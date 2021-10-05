part of '../profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
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
  });

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
      ];
}
