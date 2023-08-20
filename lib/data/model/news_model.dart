import 'package:hive/hive.dart';
part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String author;
  @HiveField(5)
  final String image;
  @HiveField(6)
  final String language;
  @HiveField(7)
  final List<String> category;
  @HiveField(8)
  final DateTime published;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.image,
    required this.language,
    required this.category,
    required this.published,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      author: json['author'],
      image: json['image'],
      language: json['language'],
      category: List<String>.from(json['category']),
      published: DateTime.parse(json['published']),
    );
  }
}
