import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:news_app/core/api.dart';
import 'package:news_app/data/model/news_model.dart';

part 'get_news_event.dart';
part 'get_news_state.dart';

class GetNewsBloc extends Bloc<GetNewsEvent, GetNewsState> {
  List<NewsModel> allNews = [];
  List<String> categories = [];
  final Api api = Api();
  GetNewsBloc() : super(GetNewsInitial()) {
    on<GetNews>((event, emit) async {
      emit(GetNewsLoading(state.news));
      try {
        Response response = await api.sendRequest.get(
            "/latest-news?language=en&apiKey=mntEPV5_lbo4uH8BMseW7CJAFgXJDhRHU7WG308_j7SUrtwC");

        if (response.statusCode == 200) {
          print(" Shree success");
          allNews = (response.data['news'] as List<dynamic>)
              .map((json) => NewsModel.fromJson(json))
              .toList();

          Set<String> uniqueCategories = <String>{};

          for (var newsItem in allNews) {
            uniqueCategories.addAll(newsItem.category);
          }
          categories = uniqueCategories.toList();
          print(categories);

          emit(NewsLoaded(allNews, categories));
        } else {
          emit(GetNewsError("Oops...! something went worng", state.news));
        }
      } catch (e) {
        emit(GetNewsError(e.toString(), state.news));
      }
    });

    on<FilteredListNews>((event, emit) {
      if (state is NewsLoaded) {
        if (event.category == "All") {
          emit(NewsLoaded(allNews, categories));
        } else {
          final filteredNews = allNews
              .where(
                (newsItem) => newsItem.category.contains(event.category),
              )
              .toList();
          emit(NewsLoaded(filteredNews, categories));
        }
      }
    });
  }
}
