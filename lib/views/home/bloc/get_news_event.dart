part of 'get_news_bloc.dart';

class GetNewsEvent {}

class GetNews extends GetNewsEvent {}

class FilteredListNews extends GetNewsEvent {
  final String category;
  FilteredListNews({required this.category});
}
