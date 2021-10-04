import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/services/activity_service.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/utils/common_function.dart';
import 'package:seller_app/utils/common_utils.dart';

part 'events/request_detail_event.dart';
part 'states/request_detail_state.dart';

class RequestDetailBloc extends Bloc<RequestDetailEvent, RequestDetailState> {
  RequestDetailBloc({
    required String id,
    ActivityService? activityService,
  }) : super(RequestDetailState(id: id)) {
    _activityService = activityService ?? getIt.get<ActivityService>();
  }

  late ActivityService _activityService;
  @override
  Stream<RequestDetailState> mapEventToState(RequestDetailEvent event) async* {
    if (event is RequestDetailInitial) {
      try {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionInProgress,
        );

        var data = await futureAppDuration(
          _activityService.getRequetsDetail(state.id),
        );

        if (data != null) {
          yield data.copyWith(
            stateStatus: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception();
        }
      } catch (e) {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionFailure,
        );
      }
    } else if (event is RequestDetailInitialTest) {
      try {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionInProgress,
        );

        await CommonTest.delay();

        RequestDetailState? data = null;

        data = getState();

        if (data != null) {
          yield data.copyWith(
            stateStatus: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception();
        }
      } catch (e) {
        yield state.copyWith(
          stateStatus: FormzStatus.submissionFailure,
        );
      }
    }
  }

  RequestDetailState getState() {
    var dataNullImage = RequestDetailState(
      status: 1,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      createdTime: '09:41',
    );

    var cancelBySeller = RequestDetailState(
      status: 2,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      createdTime: '09:41',
    );
    return cancelBySeller;
  }
}
