import 'dart:async';

import '../../core/api.dart';
import '../model/news_model.dart';

class SearchNewsRepo {
  final _searchController = StreamController<List<NewsModel>>();
  Stream<List<NewsModel>> get searchResultsStream => _searchController.stream;
  final Api api = Api();
  void searchNews(String keywords) async {
    final response = await api.sendRequest.get(
        "/search?keywords=$keywords&language=en&apiKey=mntEPV5_lbo4uH8BMseW7CJAFgXJDhRHU7WG308_j7SUrtwC");

    if (response.statusCode == 200) {
      final List<NewsModel> newsData = (response.data['news'] as List<dynamic>)
          .map((json) => NewsModel.fromJson(json))
          .toList();
      _searchController.sink.add(newsData);
    } else {
      throw Exception("Failed to Get Data");
    }
  }

  void dispose() {
    _searchController.close();
  }
}
