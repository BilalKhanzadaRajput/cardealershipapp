part of 'dashboard_screen_bloc.dart';

class DashBoardScreenState extends Equatable {
  final bool isLoading;
  final List<Map<String, String>>
      images; // List of maps to hold image and text pairs
  final int activeIndex;
  final bool hasError;
  final bool logOutUser;

  DashBoardScreenState({
    required this.isLoading,
    required this.images,
    required this.activeIndex,
    required this.hasError,
    this.logOutUser = false,
  });

  DashBoardScreenState copyWith({
    bool? isLoading,
    List<Map<String, String>>? images,
    int? activeIndex,
    bool? hasError,
    bool? logOutUser,
  }) {
    return DashBoardScreenState(
      isLoading: isLoading ?? this.isLoading,
      images: images ?? this.images,
      activeIndex: activeIndex ?? this.activeIndex,
      hasError: hasError ?? this.hasError,
      logOutUser: logOutUser ?? this.logOutUser,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, images, activeIndex, hasError, logOutUser];
}
