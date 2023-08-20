import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:news_app/views/search/search_news.dart';
import 'package:news_app/views/single_news.dart';

import '../../data/model/news_model.dart';
import 'bloc/get_news_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetNewsBloc getNewsBloc = GetNewsBloc();
  late Box<NewsModel> newsBox;
  bool isSaved = false;

  int currentTab = 50;
  List<String> categories = ["Women's", "Ethnic", "Fashion", "Accessories"];

  @override
  void initState() {
    openHiveBox().then((value) {
      getNewsBloc.add(GetNews());
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
      backgroundColor: Colors.white,
      body: BlocBuilder<GetNewsBloc, GetNewsState>(
        bloc: getNewsBloc,
        builder: (context, state) {
          if (state is GetNewsLoading && state.news.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          if (state is GetNewsError && state.news.isEmpty) {
            return Center(
              child: Text(state.errMsg),
            );
          } else if (state is NewsLoaded && state.news.isEmpty) {
            return const Center(
              child: Text("Oops...There are no latest news"),
            );
          } else if (state is NewsLoaded && state.news.isNotEmpty) {
            return SafeArea(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchNews()));
                    },
                    child: Container(
                      height: 40,
                      width: size.width,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade400,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Search...",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade400),
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentTab = 50;
                            });
                            getNewsBloc.add(
                              FilteredListNews(category: "All"),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 21),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: currentTab == 50
                                    ? Colors.black
                                    : Colors.white),
                            child: Text(
                              "All",
                              style: TextStyle(
                                fontSize: 18,
                                color: currentTab == 50
                                    ? Colors.white
                                    : const Color.fromRGBO(128, 129, 145, 1),
                              ),
                            ),
                          ),
                        ),
                        ...List.generate(
                            state.categories.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentTab = index;
                                    });
                                    getNewsBloc.add(
                                      FilteredListNews(
                                          category: state.categories[index]),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 20 : 4, right: 4),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 21),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: currentTab == index
                                            ? Colors.black
                                            : Colors.white),
                                    child: Text(
                                      state.categories[index],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: currentTab == index
                                            ? Colors.white
                                            : const Color.fromRGBO(
                                                128, 129, 145, 1),
                                      ),
                                    ),
                                  ),
                                ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.news.length,
                        itemBuilder: (context, index) {
                          final newsItem = state.news[index];
                          final newsId = newsItem.id;
                          isSaved = newsBox.containsKey(newsId);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SingleNews(
                                            news: state.news[index],
                                            isSaved: isSaved,
                                          )));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 3),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.news[index].title,
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
                                              setState(() {
                                                isSaved == true;
                                              });
                                              final newsBox =
                                                  await Hive.openBox<NewsModel>(
                                                      'newsBox');
                                              newsBox.add(state.news[index]);
                                            },
                                            child: FaIcon(
                                              isSaved == true
                                                  ? FontAwesomeIcons
                                                      .solidBookmark
                                                  : FontAwesomeIcons.bookmark,
                                              color: Colors.black45,
                                              size: 18,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${state.news[index].published}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey.shade400),
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
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              state.news[index].image != "None"
                                                  ? state.news[index].image
                                                  : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
