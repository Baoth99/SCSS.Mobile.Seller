import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/events/abstract_event.dart';

part 'states/main_state.dart';
part 'events/main_event.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState());

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is MainBarItemTapped) {
      yield state.copyWith(screenIndex: event.index);
    } else if (event is MainInitial) {
      add(const MainBarItemTapped(0));
    }
  }
}
