import 'package:equatable/equatable.dart';

abstract class ProfileScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileScreenEvent {}

class ToggleEditMode extends ProfileScreenEvent {}

class UpdateFullName extends ProfileScreenEvent {
  final String fullName;
  UpdateFullName(this.fullName);
  @override
  List<Object?> get props => [fullName];
}

class UpdatePhoneNumber extends ProfileScreenEvent {
  final String phoneNumber;
  UpdatePhoneNumber(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateShowroomName extends ProfileScreenEvent {
  final String showroomName;
  UpdateShowroomName(this.showroomName);
  @override
  List<Object?> get props => [showroomName];
}

class SaveProfile extends ProfileScreenEvent {}

class CheckEditPermission extends ProfileScreenEvent {
  @override
  List<Object?> get props => [];
}

class FetchProfileDataEvent extends ProfileScreenEvent {} 