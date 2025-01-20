import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_screen_event.dart';

part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginScreenBloc() : super(const LoginScreenState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<PasswordVisibility>(_onPasswordVisibility);
    on<LoginSubmit>(_onSubmit);
  }

  void _onEmailChanged(
      LoginEmailChanged event, Emitter<LoginScreenState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordVisibility(
      PasswordVisibility event, Emitter<LoginScreenState> emit) {
    emit(state.copyWith(passwordVisibility: !state.passwordVisibility));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginScreenState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onSubmit(LoginSubmit event, Emitter<LoginScreenState> emit) async {
    emit(state.copyWith(isloading: true));

    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(isloading: false, isSuccess: true));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          isloading: false, isFailure: true, errorMessage: e.message));
    }
    emit(state.copyWith(
      isloading: false,
      isSuccess: false,
      isFailure: false,
      errorMessage: '',
    ));
  }
}
