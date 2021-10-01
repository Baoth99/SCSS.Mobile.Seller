import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/identity_server_service.dart';
import 'package:seller_app/utils/common_utils.dart';
part 'events/account_event.dart';
part 'states/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  late IdentityServerService _identityServerService;
  AccountBloc({IdentityServerService? identityServerService})
      : super(const AccountState()) {
    _identityServerService =
        identityServerService ?? getIt.get<IdentityServerService>();
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is LogoutEvent) {
      try {
        yield state.copyWith(
          status: FormzStatus.submissionInProgress,
        );

        var result = await _identityServerService.connectRevocation();

        if (result) {
          if (await SharedPreferenceUtils.remove(APIKeyConstants.accessToken) &&
              await SharedPreferenceUtils.remove(
                  APIKeyConstants.refreshToken)) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
            );
          } else {
            throw Exception();
          }
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
