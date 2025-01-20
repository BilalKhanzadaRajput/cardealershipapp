part of 'login_screen_bloc.dart';

class LoginScreenState extends Equatable {
  final String email;
  final String password;
  final bool isloading;
  final bool isSuccess;
  final bool isFailure;
  final bool passwordVisibility;
  final String? errorMessage;
  final String? successMessage;

  const LoginScreenState({
    this.email = '',
    this.password = '',
    this.passwordVisibility = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.isSuccess = false,
    this.isFailure = false,
    this.isloading = false,
  });

  LoginScreenState copyWith({
    String? email,
    String? password,
    bool? passwordVisibility,
    String? errorMessage,
    String? successMessage,
    bool? isSuccess,
    bool? isFailure,
    bool?isloading,
  }) {
    return LoginScreenState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFailure: isFailure ?? this.isFailure ,
      isloading: isloading ?? this.isloading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, passwordVisibility, errorMessage, successMessage, isFailure, isloading, isSuccess];
}
