import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/model/news_model.dart';
import '../../services/formatter.dart';
import '../single_news.dart';

class BookMarkedScreen extends StatefulWidget {
  const BookMarkedScreen({super.key});

  @override
  State<BookMarkedScreen> createState() => _BookMarkedScreenState();
}

class _BookMarkedScreenState extends State<BookMarkedScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox<NewsModel>('newsBox'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final newsBox = Hive.box<NewsModel>('newsBox');
              final List<NewsModel> newsList = newsBox.values.toList();

              return newsList.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: newsList.length,
                              itemBuilder: (context, index) {
                                final newsItem = newsList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SingleNews(
                                                  news: newsItem,
                                                  isSaved: true,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 3),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              newsItem.title,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    try {
                                                      final newsBox = await Hive
                                                          .openBox<NewsModel>(
                                                              'newsBox');
                                                      await newsBox
                                                          .delete(newsItem.id);
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.black54,
                                                    size: 18,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  Formatter.formatDate(
                                                      "${newsItem.published}"),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: size.width * 0.27,
                                          width: size.width * 0.27,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    newsItem.image != "None"
                                                        ? newsItem.image
                                                        : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                                                  ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              // itemBuilder: (context, index) {
                              //   final newsItem = newsList[index];
                              //   return ListTile(
                              //     title: Text(newsItem.title),
                              //     subtitle: Text(newsItem.description),
                              //     // ... other fields
                              //   );
                              // },
                              ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "No BookMarks Available",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error opening Hive box.'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
