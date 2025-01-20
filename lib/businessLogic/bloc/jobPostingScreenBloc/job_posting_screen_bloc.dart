import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../dataProvider/models/job_announcement_model.dart';

part 'job_posting_screen_event.dart';
part 'job_posting_screen_state.dart';

class JobPostingScreenBloc extends Bloc<JobPostingScreenEvent, JobPostingScreenState> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  JobPostingScreenBloc() : super(JobPostingScreenState()) {
    on<AddJobEvent>(_addJob);
    on<FetchJobsEvent>(_fetchJobs);
    on<IsUserAdmin>(_isUserAdmin);
  }


  Future<void> _addJob(AddJobEvent event,
      Emitter<JobPostingScreenState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _database.collection('jobs').add(event.job.toMap());
      final jobs = await _fetchJobsFromFirestore();
      emit(state.copyWith(jobs: jobs, isLoading: false, isSuccess: true));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.message));
    }
  }

  Future<void> _fetchJobs(FetchJobsEvent event,
      Emitter<JobPostingScreenState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final jobs = await _fetchJobsFromFirestore();
      emit(state.copyWith(jobs: jobs, isLoading: false, isSuccess: true));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          isLoading: false, isFailure: true, errorMessage: e.message));
    }
  }

  Future<List<JobAnnouncement>> _fetchJobsFromFirestore() async {
    final snapshot = await _database.collection('jobs').get();
    return snapshot.docs.map((doc) => JobAnnouncement.fromMap(doc.data()))
        .toList();
  }


  Future<void> _isUserAdmin (IsUserAdmin event, Emitter<JobPostingScreenState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await _database.collection('users').doc(user?.uid).get();
    final isAdmin = userDoc.data()?['isAdmin'] ?? false;
    emit(state.copyWith(isAdmin: isAdmin));

  }
}
