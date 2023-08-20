part of 'all_news_bloc.dart';

class AllNewsState {
  final List<NewsModel> news;
  const AllNewsState(this.news);
}

class AllNewsInitial extends AllNewsState {
  AllNewsInitial() : super([]);
}

class AllNewsLoading extends AllNewsState {
  AllNewsLoading(super.news);
}

class AllNewsLoaded extends AllNewsState {
  AllNewsLoaded(super.news);
}

class AllNewsError extends AllNewsState {
  final String errMsg;
  AllNewsError(this.errMsg, super.news);
}
