import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:news_app/widgets/text_field.dart';

import '../../data/repo/news_repo.dart';
import '../single_news.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({super.key});

  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  TextEditingController searchController = TextEditingController();
  final SearchNewsRepo searchNewsRepo = SearchNewsRepo();

  @override
  void dispose() {
    searchController.dispose();
    searchNewsRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MyTextField(
              controller: searchController,
              hintText: "Search latest news...",
              fieldType: "Search News",
              readOnly: false,
              suffix: Icon(
                Icons.search_rounded,
                color: Colors.grey.shade300,
              ),
              onChange: (value) {
                searchNewsRepo.searchNews(value);
              },
            ),
          ),
          StreamBuilder<List<NewsModel>>(
              stream: searchNewsRepo.searchResultsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final newsData = snapshot.data!;
                  return Expanded(
                      child: ListView(
                    children: [
                      ...newsData.map((newsData) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SingleNews(
                                          news: newsData,
                                          isSaved: false,
                                        )));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(7)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      newsData.title,
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
                                            newsData.image != "None"
                                                ? newsData.image
                                                : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                                          ))),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ));
                  // return ListView.builder(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 10),
                  //     itemCount: newsData.length,
                  //     itemBuilder: (context, index) {
                  // return InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (_) => SingleNews(
                  //                   news: newsData[index],
                  //                   isSaved: false,
                  //                 )));
                  //   },
                  //   child: Container(
                  //     margin: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 3),
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey.shade200),
                  //         borderRadius: BorderRadius.circular(7)),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //             child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text(
                  //               newsData[index].title,
                  //               maxLines: 3,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: const TextStyle(
                  //                 fontSize: 21,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             const SizedBox(
                  //               height: 10,
                  //             ),
                  //           ],
                  //         )),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         Container(
                  //           height: size.width * 0.27,
                  //           width: size.width * 0.27,
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(6),
                  //               image: DecorationImage(
                  //                   fit: BoxFit.cover,
                  //                   image: CachedNetworkImageProvider(
                  //                     newsData[index].image != "None"
                  //                         ? newsData[index].image
                  //                         : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                  //                   ))),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                  //     });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              })
        ],
      )),
    );
  }
}
