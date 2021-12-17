import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/address_model.dart';
import 'package:seller_app/blocs/models/birthdate_model.dart';
import 'package:seller_app/blocs/models/email_model.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/models/models.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';

part 'events/profile_edit_event.dart';
part 'states/profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc({
    String? imagePath,
    String? name,
    String? phoneNumber,
    String? address,
    String? email,
    Gender? gender,
    DateTime? dateTime,
    IdentityServerService? identityServerService,
  }) : super(
          ProfileEditState(
            imagePath: imagePath,
            name: Name.pure(name ?? Symbols.empty),
            phoneNumber: phoneNumber ?? Symbols.empty,
            address: Address.pure(address ?? Symbols.empty),
            email: Email.pure(email ?? Symbols.empty),
            gender: gender ?? Gender.male,
            birthDate: Birthdate.pure(dateTime),
            cname: name,
            cemail: email,
            cgender: gender,
            cbirthDate: dateTime,
            caddress: address,
          ),
        ) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }
  late IdentityServerService _identityServerService;
  @override
  Stream<ProfileEditState> mapEventToState(ProfileEditEvent event) async* {
    if (event is ProfileEditImageUpdated) {
      try {
        if (state.cname != null && state.cgender != null) {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );
          var imageUrl = await _identityServerService.updateImage(event.file);
          var result = await _identityServerService.updateInfo(
            state.cname!,
            state.cemail,
            state.cgender!,
            state.cbirthDate,
            state.caddress,
            imageUrl,
          );
          if (result == NetworkConstants.ok200) {
            yield state.copyWith(
              imagePath: imageUrl,
              status: FormzStatus.submissionSuccess,
            );
          } else {
            yield state.copyWith(
              status: FormzStatus.submissionFailure,
            );
          }
        }
      } catch (e) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    } else if (event is ProfileEditNameChanged) {
      var name = Name.dirty(event.name);
      yield state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.address,
          state.email,
          state.birthDate,
        ]),
      );
    } else if (event is ProfileEditAddressChanged) {
      var address = Address.dirty(event.address);
      yield state.copyWith(
        address: address,
        status: Formz.validate([
          address,
          state.name,
          state.email,
          state.birthDate,
        ]),
      );
    } else if (event is ProfileEditEmailChanged) {
      var email = Email.dirty(event.email);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          state.address,
          state.name,
          email,
          state.birthDate,
        ]),
      );
    } else if (event is ProfileEditGenderChanged) {
      var gender = event.gender;
      yield state.copyWith(
        gender: gender,
        status: Formz.validate([
          state.address,
          state.name,
          state.email,
          state.birthDate,
        ]),
      );
      if (state.address.valid &&
          state.birthDate.valid &&
          state.name.valid &&
          state.email.valid) {
        yield state.copyWith(
          status: FormzStatus.valid,
        );
      }
    } else if (event is ProfileEditBirthDateChanged) {
      var birthdate = Birthdate.dirty(event.dateTime);

      yield state.copyWith(
        birthDate: birthdate,
        status: Formz.validate(
          [
            state.address,
            state.name,
            state.email,
            birthdate,
          ],
        ),
      );
    } else if (event is ProfileEditSubmmited) {
      yield state.copyWith(
        status: FormzStatus.submissionInProgress,
      );
      try {
        var result = await _identityServerService.updateInfo(
          state.name.value,
          state.email.value,
          state.gender,
          state.birthDate.value,
          state.address.value,
          state.imagePath,
        );
        if (result == NetworkConstants.ok200) {
          yield state.copyWith(
            cname: state.name.value,
            cemail: state.email.value,
            caddress: state.address.value,
            cgender: state.gender,
            cbirthDate: state.birthDate.value,
            status: FormzStatus.submissionSuccess,
          );
        } else {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
        yield state.copyWith(
          status: FormzStatus.pure,
        );
      } catch (e) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
