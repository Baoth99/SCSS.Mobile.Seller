part of '../main_bloc.dart';

abstract class MainEvent extends AbstractEvent {
  const MainEvent();
}

class MainInitial extends MainEvent {}

class MainBarItemTapped extends MainEvent {
  const MainBarItemTapped(this.index);

  final int index;

  @override
  List<int> get props => [index];
}

class MainCheckFullRequest extends MainEvent {}

class MainActivityChanged extends MainEvent {
  const MainActivityChanged(this.index);

  final int index;

  @override
  List<int> get props => [index];
}
