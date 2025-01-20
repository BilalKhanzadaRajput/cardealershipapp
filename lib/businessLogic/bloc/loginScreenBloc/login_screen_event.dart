part of 'login_screen_bloc.dart';

abstract class LoginScreenEvent extends Equatable {
  const LoginScreenEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginScreenEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginScreenEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class PasswordVisibility extends LoginScreenEvent {}

class LoginSubmit extends LoginScreenEvent {}
