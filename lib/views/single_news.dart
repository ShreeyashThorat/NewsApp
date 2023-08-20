import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:news_app/views/webview.dart';

class SingleNews extends StatefulWidget {
  final NewsModel news;
  final bool isSaved;
  const SingleNews({Key? key, required this.news, required this.isSaved})
      : super(key: key);

  @override
  State<SingleNews> createState() => _SingleNewsState();
}

class _SingleNewsState extends State<SingleNews> {
  late Box<NewsModel> newsBox;
  @override
  void initState() {
    super.initState();
  }

  Future<void> openHiveBox() async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: SizedBox(
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
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                widget.news.image != "None"
                                    ? widget.news.image
                                    : "https://img.freepik.com/premium-photo/newspaper-glasses-with-copy-space_225446-8754.jpg?size=626&ext=jpg&ga=GA1.2.106044016.1687106274&semt=sph",
                              ))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.news.title,
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
                      widget.news.description,
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
                      "~  ${widget.news.author}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final newsBox =
                            await Hive.openBox<NewsModel>('newsBox');
                        newsBox.add(widget.news);
                      },
                      icon: FaIcon(
                        widget.isSaved == true
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
                                      NewsWebView(news: widget.news.url)));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.black),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
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
        ),
      ),
    );
  }
}
