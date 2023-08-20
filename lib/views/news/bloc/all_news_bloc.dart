import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../core/api.dart';
import '../../../data/model/news_model.dart';

part 'all_news_event.dart';
part 'all_news_state.dart';

class AllNewsBloc extends Bloc<AllNewsEvent, AllNewsState> {
  final Api api = Api();
  AllNewsBloc() : super(AllNewsInitial()) {
    on<GetAllNews>((event, emit) async {
      emit(AllNewsLoading(state.news));
      try {
        Response response = await api.sendRequest.get(
            "/latest-news?language=en&apiKey=mntEPV5_lbo4uH8BMseW7CJAFgXJDhRHU7WG308_j7SUrtwC");

        if (response.statusCode == 200) {
          print(" Shree success");
          final List<NewsModel> allNews =
              (response.data['news'] as List<dynamic>)
                  .map((json) => NewsModel.fromJson(json))
                  .toList();

          emit(AllNewsLoaded(allNews));
        } else {
          emit(AllNewsError("Oops...! something went worng", state.news));
        }
      } catch (e) {
        emit(AllNewsError(e.toString(), state.news));
      }
    });
  }
}
