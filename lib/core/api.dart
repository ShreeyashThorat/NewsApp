import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String baseURL = "https://api.currentsapi.services/v1";

const Map<String, dynamic> defaultHEADERS = {
  "Content-Type": "application/json"
};

class Api {
  final Dio _dio = Dio();

  Api() {
    _dio.options.baseUrl = baseURL;
    _dio.options.headers = defaultHEADERS;
    _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));
  }

  Dio get sendRequest => _dio;
}

class NewsResponse {
  dynamic news;
  String status;
  String page;

  NewsResponse({required this.status, required this.news, required this.page});

  factory NewsResponse.fromResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return NewsResponse(
        status: data["status"], news: data["news"], page: data["page"]);
  }
}
