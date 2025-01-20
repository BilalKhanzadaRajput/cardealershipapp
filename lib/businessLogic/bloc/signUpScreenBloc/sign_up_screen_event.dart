part of 'sign_up_screen_bloc.dart';

abstract class SignUpScreenEvent extends Equatable {
  const SignUpScreenEvent();
}

class SignUpFullNameChanged extends SignUpScreenEvent {
  final String fullName;

  const SignUpFullNameChanged(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class SignUpFatherNameChanged extends SignUpScreenEvent {
  final String fatherName;

  const SignUpFatherNameChanged(this.fatherName);

  @override
  List<Object> get props => [fatherName];
}

class SignUpEmailChanged extends SignUpScreenEvent {
  final String email;

  const SignUpEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

// class SignUpCnicChanged extends SignUpScreenEvent {
//   final String cnic;

//   const SignUpCnicChanged(this.cnic);

//   @override
//   List<Object> get props => [cnic];
// }


class SignUpPhoneChanged extends SignUpScreenEvent {
  final String phone;

  const SignUpPhoneChanged(this.phone);

  @override
  List<Object> get props => [phone];
}

class SignUpDistrictChanged extends SignUpScreenEvent {
  final String district;

  const SignUpDistrictChanged(this.district);

  @override
  List<Object> get props => [district];
}

class SignUpPasswordChanged extends SignUpScreenEvent {
  final String password;

  const SignUpPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignUpConfirmPasswordChanged extends SignUpScreenEvent {
  final String confirmPassword;

  const SignUpConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class SignUpSubmit extends SignUpScreenEvent {
  const SignUpSubmit();

  @override
  List<Object> get props => [];
}

class PasswordVisibility extends SignUpScreenEvent {
  const PasswordVisibility();

  @override
  List<Object> get props => [];
}

class SignUpShowroomOwnerChanged extends SignUpScreenEvent {
  final bool isShowroomOwner;

  const SignUpShowroomOwnerChanged(this.isShowroomOwner);

  @override
  List<Object?> get props => [isShowroomOwner];
}

class SignUpShowroomNameChanged extends SignUpScreenEvent {
  final String showroomName;

  const SignUpShowroomNameChanged(this.showroomName);

  @override
  List<Object?> get props => [showroomName];
}
