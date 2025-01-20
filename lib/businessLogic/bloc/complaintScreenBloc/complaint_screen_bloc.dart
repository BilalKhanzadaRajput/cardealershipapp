import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../dataProvider/models/complaint_model.dart';


part 'complaint_screen_event.dart';

part 'complaint_screen_state.dart';

class ComplaintScreenBloc
    extends Bloc<ComplaintScreenEvent, ComplaintScreenState> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  ComplaintScreenBloc() : super(const ComplaintScreenState()) {
    on<AddComplaintEvent>(_addComplaint);
    on<FetchComplaintsEvent>(_fetchComplaints);
  }
  Future<void> _addComplaint(
      AddComplaintEvent event,
      Emitter<ComplaintScreenState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-logged-in',
            message: 'User is not logged in.'
        );
      }

      final userDoc = await _database.collection('users').doc(user.uid).get();
      final isAdmin = userDoc.data()?['isAdmin'] ?? false;

      await _database.collection('complaints').add(event.complaint.toMap());
      final complaints = await _fetchComplaintsFromFirestore(user.uid, isAdmin);

      emit(state.copyWith(
          complaint: complaints,
          isLoading: false,
          isSuccess: true,
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          errorMessage: e.message
      ));
    }
  }

  Future<void> _fetchComplaints(
      FetchComplaintsEvent event,
      Emitter<ComplaintScreenState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-logged-in',
            message: 'User is not logged in.'
        );
      }

      final userDoc = await _database.collection('users').doc(user.uid).get();
      final isAdmin = userDoc.data()?['isAdmin'] ?? false;

      final complaints = await _fetchComplaintsFromFirestore(user.uid, isAdmin);

      emit(state.copyWith(
          complaint: complaints,
          isLoading: false,
          isSuccess: true
      ));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          isLoading: false,
          isFailure: true,
          errorMessage: e.message
      ));
    }
  }

  Future<List<Complaint>> _fetchComplaintsFromFirestore(
      String userId, bool isAdmin) async {
    final query = _database.collection('complaints');

    final snapshot = isAdmin
        ? await query.get()
        : await query.where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Complaint.fromMap(data);
    }).toList();
  }


  }


//for user
//Future<void> _addComplaint(AddComplaintEvent event,
//       Emitter<ComplaintScreenState> emit) async {
//     try {
//       emit(state.copyWith(isLoading: true));
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       await _database.collection('complaints').add(event.complaint.toMap());
//       final complaints = await _fetchComplaintsFromFirestore(userId);
//       emit(state.copyWith(
//           complaint: complaints,
//           isLoading: false,
//           isSuccess: true
//       ));
//     } on FirebaseException catch (e) {
//       emit(state.copyWith(
//           isLoading: false,
//           isFailure: true,
//           errorMessage: e.message
//       ));
//     }
//   }
//
//   Future<void> _fetchComplaints(FetchComplaintsEvent event,
//       Emitter<ComplaintScreenState> emit) async {
//     try {
//       emit(state.copyWith(isLoading: true));
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       final complaints = await _fetchComplaintsFromFirestore(userId);
//       emit(state.copyWith(
//           complaint: complaints,
//           isLoading: false,
//           isSuccess: true
//       ));
//     } on FirebaseException catch (e) {
//       emit(state.copyWith(
//           isLoading: false,
//           isFailure: true,
//           errorMessage: e.message
//       ));
//     }
//   }
//
//   Future<List<Complaint>> _fetchComplaintsFromFirestore(String userId) async {
//     final snapshot = await _database
//         .collection('complaints')
//         .where('userId', isEqualTo: userId)
//         .get();
//     return snapshot.docs.map((doc) => Complaint.fromMap(doc.data())).toList();
//   }
// }