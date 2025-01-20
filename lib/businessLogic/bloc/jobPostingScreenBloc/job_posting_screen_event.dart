part of 'job_posting_screen_bloc.dart';

abstract class JobPostingScreenEvent {}

class AddJobEvent extends JobPostingScreenEvent {
  final JobAnnouncement job;

  AddJobEvent(this.job);
}

class FetchJobsEvent extends JobPostingScreenEvent {}

class IsUserAdmin extends JobPostingScreenEvent {}