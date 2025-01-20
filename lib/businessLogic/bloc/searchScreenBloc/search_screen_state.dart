part of 'search_screen_bloc.dart';

class SearchScreenState {
  final List<Map<String, dynamic>> data;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;

  SearchScreenState({
    this.data = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
  });

  factory SearchScreenState.loading() => SearchScreenState(isLoading: true);
  factory SearchScreenState.success(List<Map<String, dynamic>> data) =>
      SearchScreenState(data: data, isSuccess: true);
  factory SearchScreenState.failure() => SearchScreenState(isFailure: true);
}