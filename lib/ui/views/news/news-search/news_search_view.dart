// ignore: file_names
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_model.dart';
import 'package:freecodecamp/ui/views/news/news_helpers.dart';
import 'dart:developer' as dev;

import 'package:stacked/stacked.dart';

class NewsSearchView extends StatelessWidget {
  const NewsSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsSearchModel>.reactive(
        viewModelBuilder: () => NewsSearchModel(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: model.searchbarController,
                decoration: const InputDecoration(
                    hintText: "SEARCH ARTICLE...",
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    filled: true),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  model.setSearchTerm(value);
                },
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFF0a0a23),
            ),
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(model.search(model.getSearchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) return Text('Error: ${snapshot.error}');

                List<AlgoliaObjectSnapshot>? current = snapshot.data;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: current!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 75,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2, color: Colors.white))),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  child: Text(
                                    NewsHelper.truncateStr(
                                        current[index].data['title']),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () => {
                                    model.navigateToArticle(
                                        current[index].data["objectID"])
                                  },
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                );
              },
            )));
  }
}
