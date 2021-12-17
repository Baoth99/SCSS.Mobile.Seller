part of '../profile_bloc.dart';

abstract class ProfileEvent extends AbstractEvent {
  const ProfileEvent();
}

class ProfileInitial extends ProfileEvent {}

class ProfileInitialAll extends ProfileEvent {}

class ProfileImageUpdated extends ProfileEvent {}

class ProfileClear extends ProfileEvent {}
