part of '../profile_edit_bloc.dart';

class ProfileEditEvent extends AbstractEvent {
  const ProfileEditEvent();
}

class ProfileEditSubmmited extends ProfileEditEvent {}

class ProfileEditImageUpdated extends ProfileEditEvent {
  ProfileEditImageUpdated(this.file);
  final File file;
}

class ProfileEditNameChanged extends ProfileEditEvent {
  final String name;
  ProfileEditNameChanged(this.name);
}

class ProfileEditEmailChanged extends ProfileEditEvent {
  final String email;
  ProfileEditEmailChanged(this.email);
}

class ProfileEditAddressChanged extends ProfileEditEvent {
  final String address;
  ProfileEditAddressChanged(this.address);
}

class ProfileEditGenderChanged extends ProfileEditEvent {
  final Gender gender;
  ProfileEditGenderChanged(this.gender);
}

class ProfileEditBirthDateChanged extends ProfileEditEvent {
  final DateTime dateTime;
  ProfileEditBirthDateChanged(this.dateTime);
}
