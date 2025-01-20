part of 'dashboard_screen_bloc.dart';

abstract class DashBoardScreenEvent extends Equatable {
  const DashBoardScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchImagesEvent extends DashBoardScreenEvent {}

class UpdateActiveIndexEvent extends DashBoardScreenEvent {
  final int index;

  const UpdateActiveIndexEvent(this.index);

  @override
  List<Object> get props => [index];
}

class LogOutUser extends DashBoardScreenEvent {}