part of 'complaint_screen_bloc.dart';

abstract class ComplaintScreenEvent {
}

class AddComplaintEvent extends ComplaintScreenEvent {
  final Complaint complaint;

  AddComplaintEvent(this.complaint);
}

class FetchComplaintsEvent extends ComplaintScreenEvent {}
