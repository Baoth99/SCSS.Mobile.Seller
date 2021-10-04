import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_function.dart';

part 'events/profile_event.dart';
part 'states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({IdentityServerService? identityServerService})
      : super(const ProfileState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  late IdentityServerService _identityServerService;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileInitial) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var newState =
            await futureAppDuration(_identityServerService.getProfile());

        if (newState != null) {
          yield newState.copyWith(
            status: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception();
        }
      } catch (e) {
        yield state.copyWith(
          status: FormzStatus.submissionFailure,
        );
      }
    }
  }
}
