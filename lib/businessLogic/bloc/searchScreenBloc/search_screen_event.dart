part of 'search_screen_bloc.dart';

abstract class SearchScreenEvent {}

class SearchDataEvent extends SearchScreenEvent {
  final String query;

  SearchDataEvent(this.query);
}