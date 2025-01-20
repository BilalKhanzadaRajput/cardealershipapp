part of 'sign_up_screen_bloc.dart';

class SignUpScreenState extends Equatable {
  final String fullName;
  final String fatherName;
  final String email;
  final String cnic;
  final String phone;
  final String district;
  final String password;
  final String confirmPassword;
  final bool initial;
  final bool isSubmitting;
  final bool isSubmitted;
  final bool submissionFailed;
  final bool passwordVisibility;
  final String errorMessage;
  final bool isShowroomOwner;
  final String showroomName;

  const SignUpScreenState({
    this.fullName = '',
    this.fatherName = '',
    this.email = '',
    this.cnic = '',
    this.phone = '',
    this.district = '',
    this.password = '',
    this.confirmPassword = '',
    this.initial = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.submissionFailed = false,
    this.passwordVisibility = false,
    this.errorMessage = '',
    this.isShowroomOwner = false,
    this.showroomName = '',
  });

  SignUpScreenState copyWith({
    String? fullName,
    String? fatherName,
    String? cnic,
    String? phone,
    String? email,
    String? district,
    String? password,
    String? confirmPassword,
    bool? initial,
    bool? isSubmitting,
    bool? isSubmitted,
    bool? passwordVisibility,
    bool? submissionFailed,
    String? errorMessage,
    bool? isShowroomOwner,
    String? showroomName,
  }) {
    return SignUpScreenState(
      fullName: fullName ?? this.fullName,
      fatherName: fatherName ?? this.fatherName,
      cnic: cnic ?? this.cnic,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      district: district ?? this.district,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      submissionFailed: submissionFailed ?? this.submissionFailed,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
      initial: initial ?? this.initial,
      isShowroomOwner: isShowroomOwner ?? this.isShowroomOwner,
      showroomName: showroomName ?? this.showroomName,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        fatherName,
        email,
        cnic,
        phone,
        district,
        password,
        confirmPassword,
        isSubmitting,
        passwordVisibility,
        errorMessage,
        isSubmitted,
        submissionFailed,
        initial,
        isShowroomOwner,
        showroomName,
      ];
}
