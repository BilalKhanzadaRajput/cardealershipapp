part of 'job_posting_screen_bloc.dart';

class JobPostingScreenState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final bool isAdmin;
  final String? errorMessage;
  final String? successMessage;
  final List<JobAnnouncement> jobs;

  const JobPostingScreenState({
    this.errorMessage = '',
    this.successMessage = '',
    this.isSuccess = false,
    this.isFailure = false,
    this.isLoading = false,
    this.isAdmin = false,
    this.jobs = const [],
  });

  JobPostingScreenState copyWith({
    String? errorMessage,
    String? successMessage,
    bool? isSuccess,
    bool? isFailure,
    bool? isLoading,
    bool? isAdmin,
    List<JobAnnouncement>? jobs,
  }) {
    return JobPostingScreenState(
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFailure: isFailure ?? this.isFailure,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isAdmin: isAdmin ?? this.isAdmin,
      jobs: jobs ?? this.jobs,
    );
  }

  @override
  List<Object?> get props =>
      [errorMessage, successMessage, isFailure, isLoading, isSuccess, jobs, isAdmin];
}