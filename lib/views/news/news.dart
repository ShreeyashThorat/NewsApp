import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:news_app/views/news/bloc/all_news_bloc.dart';

import '../../data/model/news_model.dart';
import '../webview.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final AllNewsBloc allNewsBloc = AllNewsBloc();
  late Box<NewsModel> newsBox;

  @override
  void initState() {
    openHiveBox().then((value) {
      allNewsBloc.add(GetAllNews());
    });

    super.initState();
  }

  Future<void> openHiveBox() async {
    newsBox = await Hive.openBox<NewsModel>('newsBox');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<AllNewsBloc, AllNewsState>(
        bloc: allNewsBloc,
        builder: (context, state) {
          if (state is AllNewsLoading && state.news.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          if (state is AllNewsError && state.news.isEmpty) {
            return Center(
              child: Text(state.errMsg),
            );
          } else if (state is AllNewsLoaded && state.news.isEmpty) {
            return const Center(
              child: Text("Oops...There are no latest news"),
            );
          } else if (state is AllNewsLoaded && state.news.isNotEmpty) {
            return SafeArea(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.news.length,
                    itemBuilder: (context, index) {
                      final data = state.news[index];
                      final newsId = data.id;
                      final isSaved = newsBox.containsKey(newsId);
                      return SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(20),
                                children: [
                                  Container(
                                    height: size.width,
                                    width: size.height,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              data.image != "None"
                                                  ? data.image
                                                  : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                                            ))),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data.title,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    data.description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "~ ${data.author}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 2,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final newsBox =
                                          await Hive.openBox<NewsModel>(
                                              'newsBox');
                                      newsBox.add(data);
                                    },
                                    icon: FaIcon(
                                      isSaved == true
                                          ? FontAwesomeIcons.solidBookmark
                                          : FontAwesomeIcons.bookmark,
                                      color: Colors.black45,
                                      size: 20,
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsWebView(
                                                        news: data.url)));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Colors.black),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Read More",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }));
          }
          return Container();
        },
      ),
    );
  }
}
