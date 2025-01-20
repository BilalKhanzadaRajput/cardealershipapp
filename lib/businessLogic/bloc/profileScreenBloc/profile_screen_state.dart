import 'package:equatable/equatable.dart';

class ProfileScreenState extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isShowroomOwner;
  final String showroomName;
  final bool isEditing;
  final bool isLoading;
  final String? errorMessage;
  final bool hasEditPermission;

  const ProfileScreenState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.isShowroomOwner = false,
    this.showroomName = '',
    this.isEditing = false,
    this.isLoading = false,
    this.errorMessage,
    this.hasEditPermission = false,
  });

  ProfileScreenState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isShowroomOwner,
    String? showroomName,
    bool? isEditing,
    bool? isLoading,
    String? errorMessage,
    bool? hasEditPermission,
  }) {
    return ProfileScreenState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isShowroomOwner: isShowroomOwner ?? this.isShowroomOwner,
      showroomName: showroomName ?? this.showroomName,
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasEditPermission: hasEditPermission ?? this.hasEditPermission,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        phoneNumber,
        isShowroomOwner,
        showroomName,
        isEditing,
        isLoading,
        errorMessage,
        hasEditPermission,
      ];
} 