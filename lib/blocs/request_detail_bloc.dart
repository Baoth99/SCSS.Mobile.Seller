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
          yield state.copyWith(
            createdDate: data.createdDate,
            createdTime: data.createdTime,
            collectingRequestCode: data.collectingRequestCode,
            status: data.status,
            addressName: data.addressName,
            address: data.address,
            collectingRequestDate: data.collectingRequestDate,
            fromTime: data.fromTime,
            toTime: data.toTime,
            isBulky: data.isBulky,
            approvedDate: data.approvedDate,
            approvedTime: data.approvedTime,
            // collectorInfo: d.collectorInfo,
            doneActivityDate: data.doneActivityDate,
            doneActivityTime: data.doneActivityTime,
            note: data.note,
            scrapCategoryImageUrl: data.scrapCategoryImageUrl,
            isCancelable: data.isCancelable,
            stateStatus: FormzStatus.submissionSuccess,
          );
        } else {
          throw Exception();
        }
      } catch (e) {
        print(e);
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
      isCancelable: true,
    );

    var dataImage = RequestDetailState(
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
      scrapCategoryImageUrl:
          'ScrapCollectingRequestImages/ScrapCollectingRequest-10-06-2021-04:45:PM-2608b550-268a-11ec-b498-15b3d8bf91a9.jpg',
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      createdTime: '09:41',
      isCancelable: true,
    );

    var cancelBySellerBeforeApproved = RequestDetailState(
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
      isCancelable: false,
      createdTime: '09:41',
      doneActivityDate: '21 thg8, 2021',
      doneActivityTime: '10:00',
    );
    var cancelBySellerApproved = RequestDetailState(
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
      collectorName: 'Trần Văn Kiệt',
      collectorPhoneNumber: '09040203371',
      collectorRating: 4.5,
      collectorAvatarUrl:
          'SellerAccountImages/SellerAccount-10-05-2021-06:02:PM-c56f0960-25cb-11ec-87d0-4161dfaab77a.jpg',
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      isCancelable: false,
      createdTime: '09:41',
      approvedDate: '21 thg8, 2021',
      approvedTime: '11:00',
      doneActivityDate: '21 thg8, 2021',
      doneActivityTime: '10:00',
    );

    var cancelByCollector = RequestDetailState(
      status: 3,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      collectorName: 'Trần Văn Kiệt',
      collectorPhoneNumber: '09040203371',
      collectorRating: 4.5,
      collectorAvatarUrl:
          'SellerAccountImages/SellerAccount-10-05-2021-06:02:PM-c56f0960-25cb-11ec-87d0-4161dfaab77a.jpg',
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      isCancelable: false,
      createdTime: '09:41',
      approvedDate: '21 thg8, 2021',
      approvedTime: '11:00',
      doneActivityDate: '21 thg8, 2021',
      doneActivityTime: '10:00',
    );
    var approved = RequestDetailState(
      status: 4,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      collectorName: 'Trần Văn Kiệt',
      collectorPhoneNumber: '09040203371',
      collectorRating: 4.5,
      collectorAvatarUrl:
          'SellerAccountImages/SellerAccount-10-05-2021-06:02:PM-c56f0960-25cb-11ec-87d0-4161dfaab77a.jpg',
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      isCancelable: true,
      createdTime: '09:41',
      approvedDate: '21 thg8, 2021',
      approvedTime: '11:00',
    );

    var approvednotcancel = RequestDetailState(
      status: 4,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      collectorName: 'Trần Văn Kiệt',
      collectorPhoneNumber: '09040203371',
      collectorRating: 4.5,
      collectorAvatarUrl:
          'SellerAccountImages/SellerAccount-10-05-2021-06:02:PM-c56f0960-25cb-11ec-87d0-4161dfaab77a.jpg',
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      isCancelable: false,
      createdTime: '09:41',
      approvedDate: '21 thg8, 2021',
      approvedTime: '11:00',
    );

    var done = RequestDetailState(
      status: 5,
      id: '1234567890',
      collectingRequestCode: '12423dfklgdfghdfgh',
      addressName: 'Khu dân cư 6B Kiên Cường',
      address:
          'Đường số 7, Bình Hưng, Bình Chánh, Thành phố Hồ Chí Minh, Vietnam',
      collectingRequestDate: 'Th 3, 24 thg 8',
      fromTime: '09:45',
      toTime: '10:00',
      isBulky: true,
      collectorName: 'Trần Văn Kiệt',
      collectorPhoneNumber: '09040203371',
      collectorRating: 4.5,
      collectorAvatarUrl:
          'SellerAccountImages/SellerAccount-10-05-2021-06:02:PM-c56f0960-25cb-11ec-87d0-4161dfaab77a.jpg',
      scrapCategoryImageUrl: null,
      note:
          'Anh nhớ là phải tới cái hẻm rồi quẹo, có gì tới gọitôi tôi sẽ ra đón. Anh có thể đổ thêm xăng vì nhà tôi đi tới tận chân trời mơi hết được cái thủ phủ của ông Lê nếu đi mà',
      createdDate: '21 thg8, 2021',
      isCancelable: false,
      createdTime: '09:41',
      approvedDate: '21 thg8, 2021',
      approvedTime: '11:00',
      doneActivityDate: '21 thg8, 2021',
      doneActivityTime: '12:00',
      point: "30",
      serviceFee: '23.000',
      itemTotal: '250.000',
      billTotal: '300.000',
      // ratingStar: 4.5,
      transaction: [
        TransactionItem(name: 'Nhựa', total: '100.000'),
        TransactionItem(name: 'Đá', total: '200.000', unitInfo: '100kg'),
        TransactionItem(name: 'Dầu', total: '300.000', unitInfo: '200kg'),
      ],
    );

    return done;
  }
}
