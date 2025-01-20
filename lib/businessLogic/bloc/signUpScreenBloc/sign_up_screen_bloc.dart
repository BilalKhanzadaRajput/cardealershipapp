import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'sign_up_screen_event.dart';

part 'sign_up_screen_state.dart';

class SignUpScreenBloc extends Bloc<SignUpScreenEvent, SignUpScreenState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  SignUpScreenBloc() : super(const SignUpScreenState()) {
    on<SignUpFullNameChanged>((event, emit) {
      emit(state.copyWith(fullName: event.fullName));
    });
    on<SignUpFatherNameChanged>((event, emit) {
      emit(state.copyWith(fatherName: event.fatherName));
    });
    // on<SignUpCnicChanged>((event, emit) {
    //   emit(state.copyWith(cnic: event.cnic));
    // });
    
    on<SignUpPhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });
    on<SignUpDistrictChanged>((event, emit) {
      emit(state.copyWith(district: event.district));
    });
    on<SignUpPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<SignUpConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });
    on<PasswordVisibility>((event, emit) {
      emit(state.copyWith(passwordVisibility: !state.passwordVisibility));
    });

    on<SignUpEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignUpShowroomOwnerChanged>((event, emit) {
      emit(state.copyWith(
        isShowroomOwner: event.isShowroomOwner,
        showroomName: event.isShowroomOwner ? state.showroomName : '',
      ));
    });

    on<SignUpShowroomNameChanged>((event, emit) {
      emit(state.copyWith(showroomName: event.showroomName));
    });

    on<SignUpSubmit>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      try {
        print('Starting sign up process...');
        print('Email: ${state.email}');
        print('Password: ${state.password}');

        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        final User? user = _auth.currentUser;
        if (user != null) {
          String userId = user.uid;
          await _database.collection('users').doc(userId).set({
            'fullName': state.fullName,
            'fatherName': state.fatherName,
            'email': state.email,
            'cnic': state.cnic,
            'phoneNumber': state.phone,
            'district': state.district,
            'isShowroomOwner': state.isShowroomOwner,
            'showroomName': state.isShowroomOwner ? state.showroomName : '',
          });
        }

        print('User created successfully with UID: ${userCredential.user!.uid}');

        emit(state.copyWith(
          isSubmitting: false,
          isSubmitted: true,
        ));
      } on FirebaseAuthException catch (e) {
        print('Error during sign up: ${e.toString()}');
        emit(state.copyWith(
          isSubmitting: false,
          submissionFailed: true,
          errorMessage: e.toString(),
        ));
      }
      finally {
        emit(state.copyWith(
          isSubmitting: false,
          isSubmitted: false,
          submissionFailed: false,
          errorMessage: '',
        ));
      }
    });
  }
}
