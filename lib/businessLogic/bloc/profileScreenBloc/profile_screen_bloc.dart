import 'package:cardealershipapp/businessLogic/bloc/profileScreenBloc/profile_screen_state.dart';
import 'package:cardealershipapp/businessLogic/bloc/profileScreenBloc/profile_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  ProfileScreenBloc() : super(const ProfileScreenState()) {
    on<LoadProfile>(_onLoadProfile);
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdatePhoneNumber>(_onUpdatePhoneNumber);
    on<UpdateShowroomName>(_onUpdateShowroomName);
    on<SaveProfile>(_onSaveProfile);
    on<FetchProfileDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        // Add your profile data fetching logic here
        
        emit(state.copyWith(isLoading: false));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    });
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileScreenState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final userData = await _database.collection('users').doc(userId).get();
        if (userData.exists) {
          final data = userData.data() as Map<String, dynamic>;
          emit(state.copyWith(
            fullName: data['fullName'] ?? '',
            email: data['email'] ?? '',
            phoneNumber: data['phoneNumber'] ?? '',
            isShowroomOwner: data['isShowroomOwner'] ?? false,
            showroomName: data['showroomName'] ?? '',
            isLoading: false,
          ));
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      emit(state.copyWith(
        errorMessage: 'Failed to load profile. Please try again.',
        isLoading: false,
      ));
    }
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<ProfileScreenState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        // Validate required fields
        if (state.fullName.trim().isEmpty) {
          emit(state.copyWith(
            errorMessage: 'Full name is required',
            isLoading: false,
          ));
          return;
        }

        if (state.phoneNumber.trim().isEmpty) {
          emit(state.copyWith(
            errorMessage: 'Phone number is required',
            isLoading: false,
          ));
          return;
        }

        // Create update map
        final Map<String, dynamic> updateData = {
          'fullName': state.fullName.trim(),
          'phoneNumber': state.phoneNumber.trim(),
        };

        // Add showroom name if user is a showroom owner
        if (state.isShowroomOwner) {
          if (state.showroomName.trim().isEmpty) {
            emit(state.copyWith(
              errorMessage: 'Showroom name is required',
              isLoading: false,
            ));
            return;
          }
          updateData['showroomName'] = state.showroomName.trim();
        }

        // Update Firestore
        await _database.collection('users').doc(userId).update(updateData);

        emit(state.copyWith(
          isLoading: false,
          isEditing: false,
          errorMessage: null,
        ));

        // Reload profile to ensure we have the latest data
        add(LoadProfile());
      }
    } catch (e) {
      print('Error saving profile: $e');
      emit(state.copyWith(
        errorMessage: 'Failed to save changes. Please try again.',
        isLoading: false,
      ));
    }
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<ProfileScreenState> emit) {
    emit(state.copyWith(
      isEditing: !state.isEditing,
      errorMessage: null,
    ));
  }

  void _onUpdateFullName(UpdateFullName event, Emitter<ProfileScreenState> emit) {
    emit(state.copyWith(
      fullName: event.fullName,
      errorMessage: null,
    ));
  }

  void _onUpdatePhoneNumber(UpdatePhoneNumber event, Emitter<ProfileScreenState> emit) {
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      errorMessage: null,
    ));
  }

  void _onUpdateShowroomName(UpdateShowroomName event, Emitter<ProfileScreenState> emit) {
    emit(state.copyWith(
      showroomName: event.showroomName,
      errorMessage: null,
    ));
  }
} 