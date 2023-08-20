part of 'get_news_bloc.dart';

class GetNewsState {
  final List<NewsModel> news;
  GetNewsState(this.news);
}

class GetNewsInitial extends GetNewsState {
  GetNewsInitial() : super([]);
}

class GetNewsLoading extends GetNewsState {
  GetNewsLoading(super.news);
}

class NewsLoaded extends GetNewsState {
  final List<String> categories;
  NewsLoaded(super.news, this.categories);
}

class GetNewsError extends GetNewsState {
  final String errMsg;
  GetNewsError(this.errMsg, super.news);
}
