import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_function.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'events/profile_event.dart';
part 'states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({IdentityServerService? identityServerService})
      : super(ProfileState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late IdentityServerService _identityServerService;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileInitialAll) {
      add(ProfileInitial());
      add(ProfileImageUpdated());
    } else if (event is ProfileInitial) {
      if (state.status != FormzStatus.submissionInProgress) {
        var oldimage = state.image;

        try {
          yield state.copyWith(
            status: FormzStatus.submissionInProgress,
          );

          var newState =
              await futureAppDuration(_identityServerService.getProfile());

          if (newState != null) {
            yield state.copyWith(
              id: newState.id,
              address: newState.address,
              birthDate: newState.birthDate,
              email: newState.email,
              gender: newState.gender,
              image: newState.image,
              name: newState.name,
              phone: newState.phone,
              totalPoint: newState.totalPoint,
              status: FormzStatus.submissionSuccess,
            );

            //update Image if
            if (newState.image != null && newState.image!.isNotEmpty) {
              var imageProfile = state.imageProfile;
              if (imageProfile == null) {
                var profileImage = await updateImage(newState.image!);
                yield state.copyWith(imageProfile: profileImage);
                AppLog.info('update image null');
              } else if (state.image != oldimage) {
                AppLog.info('update image other url');
                var profileImage = await updateImage(newState.image!);
                yield state.copyWith(imageProfile: profileImage);
              }
            }
          } else {
            throw Exception();
          }
        } catch (e) {
          AppLog.error(e);
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    } else if (event is ProfileImageUpdated) {
      try {
        if (state.image != null && state.image!.isNotEmpty) {
          var list = await getMetaDataImage(state.image!);
          if (list is List) {
            var imageProfile = NetworkImage(list[0], headers: {
              HttpHeaders.authorizationHeader: list[1],
            });
            yield state.copyWith(imageProfile: imageProfile);
          }
        }
      } catch (e) {
        AppLog.error(e);
      }
    } else if (event is ProfileClear) {
      try {
        yield ProfileState();
      } catch (e) {
        AppLog.error(e);
      }
    }
  }

  Future<ImageProvider> updateImage(String imagePath) async {
    var list = await getMetaDataImage(state.image!);
    if (list is List) {
      var imageProfile = NetworkImage(list[0], headers: {
        HttpHeaders.authorizationHeader: list[1],
      });
      return imageProfile;
    }
    throw Exception('Image provider have issue');
  }

  Future<List> getMetaDataImage(String imagePath) async {
    var bearerToken = NetworkUtils.getBearerToken();
    var url = NetworkUtils.getUrlWithQueryString(
      APIServiceURI.imageGet,
      {'imageUrl': imagePath},
    );
    return [
      url,
      await bearerToken,
    ];
  }
}
