part of 'complaint_screen_bloc.dart';

class ComplaintScreenState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;
  final String? successMessage;
  final List<Complaint> complaint;

  const ComplaintScreenState({
    this.errorMessage = '',
    this.successMessage = '',
    this.isSuccess = false,
    this.isFailure = false,
    this.isLoading = false,
    this.complaint = const [],
  });

  ComplaintScreenState copyWith({
    String? errorMessage,
    String? successMessage,
    bool? isSuccess,
    bool? isFailure,
    bool? isLoading,
    List<Complaint>? complaint,
  }) {
    return ComplaintScreenState(
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFailure: isFailure ?? this.isFailure,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      complaint: complaint ?? this.complaint,
    );
  }

  @override
  List<Object?> get props =>
      [errorMessage, successMessage, isFailure, isLoading, isSuccess, complaint];
}